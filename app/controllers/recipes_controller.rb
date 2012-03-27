class RecipesController < ApplicationController

  respond_to :json, :only => [:show, :update, :sync_wizard, :upload_step_image, :delete_step_image, :upload_image, :delete_image, :last]
  before_filter :get_or_create_recipe, :only => [:sync_wizard, :upload_step_image, :upload_image]

  def show
    render :status => 410, :text => "Gone" and return unless session[:recipe_id]
    
    @recipe = Recipe.find session[:recipe_id]
    render :layout => false
  end

  def index
    @recipes = Recipe.all
  end

  def update
    render :status => 400, :text => "Bad Request" and return unless params[:user_id] && params[:location]
    render :status => 410, :text => "Gone" and return unless session[:recipe_id]

    recipe = Recipe.find session[:recipe_id]
    render :status => 304, :text => "Not Modified" and return if recipe.published?
    
    user = User.find params[:user_id]

    if recipe.update_attributes({ :user => user, :longitude => params[:location][:longitude], :latitude => params[:location][:latitude], :city => params[:location][:city], :country => params[:location][:country] }) && recipe.publish
      session[:recipe_id] = nil
      render :status => 200, :text => "OK"
    else
      render :status => 400, :text => "Bad Request"
    end
  end

  def sync_wizard
    render :status => 410, :text => "Gone" and return if @recipe.published?

    params[:recipe][:ingredients_with_quantities_attributes].reject!{ |index,ingredient| ingredient[:name].blank? && ingredient[:quantity].blank? }

    if @recipe.update_attributes params[:recipe]
      render :new, :layout => false
    else
      render :status => 400, :text => 'Bad Request'
    end
  end

  def upload_step_image
    if @recipe.update_attributes params[:recipe]
      render :json => [@recipe.steps.where(:image_updated_at.exists => true).desc(:image_updated_at).first.to_jq_upload].to_json
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
      render :json => [@recipe.images.where(:attachment_updated_at.exists => true).desc(:attachment_updated_at).first.to_jq_upload].to_json
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
    respond_with Recipe.last
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
end
