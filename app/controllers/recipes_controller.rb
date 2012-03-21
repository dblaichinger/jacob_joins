class RecipesController < ApplicationController

  before_filter :get_or_create_recipe, :only => [:sync_wizard, :upload_step_image, :upload_image]

  def show
    @recipe = Recipe.find_by_slug(params[:id])
  end

  def index
    @recipes = Recipe.all
  end
  
  def new
  	@recipe = Recipe.new
    3.times { @recipe.images.build } #to show upload fields with form helper
    3.times { @recipe.steps.build } #to show upload fields with form helper
    
    #Get location by IP-address
    @location = request.location
  end

  def create
    @recipe = Recipe.new(params[:recipe])
    
    if @recipe.save 
      cookies[:jacob_joins_recipe] = { :value => @recipe.id, :expires => 20.years.from_now.utc }
      if cookies[:jacob_joins_user].present?
        @user = User.find(cookies[:jacob_joins_user])
        @recipe.user_id = @user.id
        @recipe.save!
      end
      redirect_to country_specific_information_upload_index_path
    else
      session[:error] = @recipe
      redirect_to recipe_upload_index_path
    end
  end

  def update
    @recipe = Recipe.find_by_slug(params[:id])

    if @recipe.update_attributes(params[:recipe])
      cookies[:jacob_joins_recipe] = { :value => @recipe.id, :expires => 20.years.from_now.utc } unless cookies[:jacob_joins_user].present?
      if cookies[:jacob_joins_user].present?
        @user = User.find(cookies[:jacob_joins_user])
        @recipe.user_id = @user.id
        @recipe.save!
      end
      redirect_to country_specific_information_upload_index_path
    else
      session[:error] = @recipe
      redirect_to recipe_upload_index_path
    end
  end

  def sync_wizard
    if @recipe.update_attributes params[:recipe]
      render :status => 200, :text => 'OK'
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
    @last_recipe = Recipe.last

    respond_to do |format|  
      format.json { render :json => @last_recipe.to_json }
    end
  end

  protected
  def get_or_create_recipe
    if session[:recipe_id].present?
      @recipe = Recipe.find(session[:recipe_id])
    else
      @recipe = Recipe.create
      session[:recipe_id] = @recipe.id
    end
  end
end
