class RecipesController < ApplicationController

  respond_to :json, :except => :index
  append_before_filter :check_recipe_id_presence, :already_published?, :check_for_user_and_location, :only => :update
  before_filter :check_recipe_id_presence, :only => :show
  before_filter :get_or_create_recipe, :only => [:sync_wizard, :upload_step_image, :upload_image]

  def show
    @recipe = Recipe.find session[:recipe_id]
    render :layout => false
  end

  def index
    @recipes = Recipe.all
    @location = Recipe.all.to_gmaps4rails
    render :layout => 'map'
  end

  def update
    user = User.find params[:user_id]

    if @recipe.update_attributes({ :user => user, :longitude => params[:location][:longitude], :latitude => params[:location][:latitude], :city => params[:location][:city], :country => params[:location][:country] }) && @recipe.publish
      @recipe = Recipe.new
      render :new, :layout => false
    else
      render :status => 400, :text => "Bad Request"
    end
  end

  def sync_wizard
    render :status => 410, :text => "Gone" and return if @recipe.published?

    params[:recipe][:ingredients_with_quantities_attributes].each do |index,ingredient|
      next if ingredient[:name].present? || ingredient[:quantity].present?
      ingredient[:_destroy] = true
    end

    params[:recipe][:steps_attributes].each do |index,step|
      if step[:description].present? || (step[:id] && @recipe.steps.find(step[:id]).image.present?)
        step[:number] = index
        next
      end

      step[:_destroy] = true
    end

    if @recipe.update_attributes params[:recipe]
      @recipe.steps.sort! { |a,b| a.number <=> b.number }
      render :new, :layout => false
    else
      render :status => 400, :text => 'Bad Request'
    end
  end

  def upload_step_image
    if @recipe.update_attributes params[:recipe]
      render :json => [@recipe.steps.where(:image_updated_at.exists => true).desc(:image_updated_at).first.to_jq_upload].to_json, :content_type => "text/html" #IE want's to download application/json content-type from iframes
    else
      render :status => 400, :text => 'Bad Request'
    end
  end

  def delete_step_image
    @recipe = Recipe.find(session[:recipe_id])
    @step = @recipe.steps.find(params[:step_id])
    if @step.image.destroy && (@step.image = nil).nil? && @recipe.save
      render :status => 200, :text => 'OK'
    else
      render :status => 400, :text => 'Bad Request'
    end
  end

  def upload_image
    if @recipe.update_attributes params[:recipe]
      render :json => [@recipe.images.where(:attachment_updated_at.exists => true).desc(:attachment_updated_at).first.to_jq_upload].to_json, :content_type => "text/html" #IE want's to download application/json content-type from iframes
    else
      render :status => 400, :text => 'Bad Request'
    end
  end

  def delete_image
    if Recipe.find(session[:recipe_id]).images.find(params[:image_id]).destroy
      render :status => 200, :text => 'OK'
    else
      render :status => 400, :text => 'Bad Request'
    end
  end

  def last
    respond_with Recipe.where(:user_id => {"$ne"=>nil}, :state => "published").order_by(:created_at => :desc).limit(3)
  end

  def getSidebar
    respond_to do |format|
      format.json render :file => 'recipes/search.html.haml'
    end
  end

  def search
    respond_to do |format|
      format.json do
        @ingredients = params[:ingredients].select {|i| i != ""}
        @recipes = []
        @recipe_match = []

        unless @ingredients.empty?
          @ingredients.each do |value|
            @query = Recipe.search_by_ingredient(value)
            @objects = @query.entries
            @objects.each do |entry|
              if @recipes.include?(entry)
                index = @recipes.index(entry)
                if @recipes[index]["count"].nil?
                  @recipes[index]["count"] = 1
                else
                  @recipes[index]["count"] += 1
                end
              else
                entry[:count] = 1
                @recipes << entry
              end
            end
          end
          @recipes.sort! {|a,b| b["count"] <=> a["count"]}
        end
      end
      format.html do
        @location = Recipe.all.to_gmaps4rails
        render :layout => 'map'
      end
    end
  end


  private
  def get_or_create_recipe
    if session[:recipe_id].present?
      @recipe = Recipe.find session[:recipe_id]
    else
      @recipe = Recipe.create
      session[:recipe_id] = @recipe.id
    end
  end

  def check_recipe_id_presence
    render :status => 410, :text => "Gone" and return unless session[:recipe_id].present?
  end

  def already_published?
    @recipe = Recipe.find session[:recipe_id]
    render :status => 304, :text => "Not Modified" and return if @recipe.published?
  end
end
