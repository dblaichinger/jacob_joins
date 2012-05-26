# RailsAdmin config file. Generated on May 15, 2012 20:36
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  config.current_user_method { current_admin_user } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, AdminUser

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, AdminUser

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['Jacob Joins', 'Admin']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }


  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 20

  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models = [CountrySpecificInformation, CsiSet, Image, Ingredient, IngredientWithQuantity, Question, Recipe, Step, User]

  # Add models here if you want to go 'whitelist mode':
  # config.included_models = [CountrySpecificInformation, CsiSet, Image, Ingredient, IngredientWithQuantity, Question, Recipe, Step, User]

  # Application wide tried label methods for models' instances
  # config.label_methods << :description # Default is [:name, :title]

  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field.
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Cross-section field configuration
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  # end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible. (visible(true))

  # config.model CountrySpecificInformation do
  #   # Found associations:
  #     configure :question_reference, :belongs_to_association 
  #     configure :user, :belongs_to_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :question, :text 
  #     configure :answer, :text 
  #     configure :city, :text 
  #     configure :country, :text 
  #     configure :latitude, :float 
  #     configure :longitude, :float 
  #     configure :question_reference_id, :bson_object_id         # Hidden 
  #     configure :user_id, :bson_object_id         # Hidden 
  #     configure :state, :text   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model CsiSet do
  #   # Found associations:
  #     configure :country_specific_informations, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :country_specific_information_ids, :serialized         # Hidden   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Image do
  #   # Found associations:
  #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :attachment_file_name, :text         # Hidden 
  #     configure :attachment_content_type, :text         # Hidden 
  #     configure :attachment_file_size, :integer         # Hidden 
  #     configure :attachment_updated_at, :datetime         # Hidden 
  #     configure :attachment, :paperclip   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Ingredient do
  #   # Found associations:
  #     configure :recipes, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :name, :string 
  #     configure :recipe_ids, :serialized         # Hidden   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model IngredientWithQuantity do
  #   # Found associations:
  #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :quantity, :string 
  #     configure :name, :string   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Question do
  #   # Found associations:
  #     configure :country_specific_informations, :has_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :text, :text   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  #config.model Recipe do
  #  configure :state, :text
  #end
  #   # Found associations:
  #     configure :user, :belongs_to_association 
  #     configure :ingredients, :has_and_belongs_to_many_association 
  #     configure :ingredients_with_quantities, :has_many_association 
  #     configure :steps, :has_many_association 
  #     configure :images, :has_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :slug, :string 
  #     configure :name, :string 
  #     configure :portions, :integer 
  #     configure :duration, :integer 
  #     configure :city, :text 
  #     configure :country, :text 
  #     configure :latitude, :float 
  #     configure :longitude, :float 
  #     configure :user_id, :bson_object_id         # Hidden 
  #     configure :ingredient_ids, :serialized         # Hidden 
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Step do
  #   # Found associations:
  #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :description, :text 
  #     configure :number, :integer 
  #     configure :image_file_name, :text         # Hidden 
  #     configure :image_content_type, :text         # Hidden 
  #     configure :image_file_size, :integer         # Hidden 
  #     configure :image_updated_at, :datetime         # Hidden 
  #     configure :image, :paperclip   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model User do
  #   # Found associations:
  #     configure :recipe, :has_one_association 
  #     configure :country_specific_informations, :has_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :firstname, :text 
  #     configure :lastname, :text 
  #     configure :email, :text 
  #     configure :age, :integer 
  #     configure :heard_from, :text 
  #     configure :gender, :text 
  #     configure :state, :text   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
end
