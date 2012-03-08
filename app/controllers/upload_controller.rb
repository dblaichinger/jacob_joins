class UploadController < Wicked::WizardController

# Each steps represent an action in the UploadController and a view-file in the upload views
steps :recipe, :user, :show_preview

#The action recipe represents Recipe#new
def recipe
  #Checks if an error happened when saving the recipe
  if session[:error]
    @recipe = session[:error]
    session[:error] = nil
    #Render recipe step and show the errors in @recipe
    render_wizard @recipe and return
  end
  #When the user already saved the recipe data sucessfully, the form should contain the values
  if cookies[:jacob_joins_recipe].present?
    @recipe = Recipe.find(cookies[:jacob_joins_recipe])
    3.times { @recipe.images.build } if @recipe.images.count == 0
    3.times { @recipe.steps.build } if @recipe.images.count == 0
  else
    @recipe = Recipe.new 
    3.times { @recipe.images.build } #to show upload fields with form helper
    3.times { @recipe.steps.build } #to show upload fields with form helper
  end
  render_wizard
end

#The action user represents User#new
def user
  #Checks if an error happened when saving the user
  if session[:error]
    @user = session[:error]
    session[:error] = nil
    #Render user step and show the errors in @user
    render_step @next_step and return
  end
  #When the user already saved the user data sucessfully, the form should contain the values
  if cookies[:jacob_joins_user].present?
    @user = User.find(cookies[:jacob_joins_user])
    #Uncomment to redirect to show_preview if user data is already known
    #redirect_to wizard_path(:show_preview) and return
  else 
    @user = User.new
  end
  #Get location by IP-address
  @location = request.location
  render_step @next_step
end

#The preview is the last step
def show_preview
  if cookies[:jacob_joins_user].present?
    @user = Recipe.find(cookies[:jacob_joins_user])
  end

  if cookies[:jacob_joins_recipe].present?
    @recipe = Recipe.find(cookies[:jacob_joins_recipe])
  end
end

#If the user wants to add another recipe, the cookie can be deleted by hitting the reset button which will direct to this action
def delete_cookie
  cookies.delete :jacob_joins_recipe #, :domain => 'jacobjoins.com'
  redirect_to recipe_upload_index_path
end

end
