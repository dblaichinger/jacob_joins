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
    respond_with Recipe.where(:user_id => {"$ne"=>nil}, :state => "published").order_by(:created_at => :desc).limit(5)
  end

def search
  respond_to do |format|
    format.json {
      @ingredients = params[:ingredients]
      @recipes = []

      @ingredients.each do |key, value|
        if Rails.cache.read(value.to_s)
          cache = JSON.parse(Rails.cache.read(value.to_s))
          @objects = cache
        else
          @query = Recipe.search_by_ingredient(value)
          @objects = @query.entries
          Rails.cache.write(value.to_s, @query.entries.to_json)   
        end
        if @recipes.empty?
          @recipes = cache || @query.entries
        else
          @objects.each do |entry|
            if @recipes.include?(entry)
              index = @recipes.index(entry)
              if @recipes[index]["count"].nil?
                @recipes[index]["count"] = 2
              else
                @recipes[index]["count"] += 1
              end
            else
              @recipes << entry
            end
          end              
        end
      end

      @recipe_match = []
      @recipes.each do |recipe|
        @recipe_match << recipe if recipe["count"] != nil
      end

      @recipe_match.sort! {|a,b| b["count"] <=> a["count"]}

      counter = 0
      while @recipe_match.count < 10
        @recipe_match << @recipes[counter]
        counter+=1
      end
      render :json => {:ingredients => @ingredients, :recipes => @recipe_match.take(10)}
    }
    format.html
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
