module RecipesHelper
  def formatted_portions(portions)
    if portions.present?
      portions > 6 ? "more than six" : portions
    else
      "unknown"
    end
  end

  def formatted_location(city, country)
    "#{city}#{ ',' if city } #{country}"
  end

  def render_default_ingredient_fields(form, object)
    html = ""

    default_ingredients = make_default_placeholders

    if object.ingredients_with_quantities.empty?
      4.times { object.ingredients_with_quantities.build } 
      object.ingredients_with_quantities = make_default_ingredients
      prefilled_fields = object.ingredients_with_quantities[0, object.ingredients_with_quantities.length - 1]

      prefilled_fields.each_index do |i|
        html << render(:partial => "recipes/ingredient_with_quantity", :locals => { :form => form, :data => prefilled_fields[i], :quantity_placeholder => default_ingredients[i][:quantity], :ingredient => default_ingredients[i][:name] }).to_s
      end
    
      custom_ingredient = object.ingredients_with_quantities.last
      html << render(:partial => "recipes/ingredient_with_quantity", :locals => { :form => form, :data => custom_ingredient, :quantity_placeholder => default_ingredients.last[:quantity], :ingredient_placeholder => default_ingredients.last[:name] }).to_s
    else
      object.ingredients_with_quantities.each do |ingredient_with_quantity|
        i = object.ingredients_with_quantities.index ingredient_with_quantity

        ingredient_placeholder = (i < 3) ? default_ingredients[i][:ingredient] : default_ingredients.last[:ingredient]
        quantity_placeholder = (i < 3) ? default_ingredients[i][:quantity] : default_ingredients.last[:quantity]

        html << render(:partial => "recipes/ingredient_with_quantity", :locals => { :form => form, :data => ingredient_with_quantity, :quantity => ingredient_with_quantity[:quantity], :quantity_placeholder => quantity_placeholder, :ingredient => ingredient_with_quantity[:name], :ingredient_placeholder => ingredient_placeholder }).to_s
      end

      object.ingredients_with_quantities.build
      html << render(:partial => "recipes/ingredient_with_quantity", :locals => { :form => form, :data => object.ingredients_with_quantities.last, :quantity_placeholder => default_ingredients.last[:quantity], :ingredient_placeholder => default_ingredients.last[:name] }).to_s
    end

    html
  end

  private
  def make_default_ingredients
    [
      { :name => "Eggs", :quantity => "" }, 
      { :name => "Onion", :quantity => "" }, 
      { :name => "Potatoes", :quantity => "" }, 
      { :name => "", :quantity => "" }
    ]
  end

  def make_default_placeholders
    [
      { :name => "Eggs", :quantity => "e.g.: 3 big" }, 
      { :name => "Onion", :quantity => "e.g.: 1 red" }, 
      { :name => "Potatoes", :quantity => "e.g.: 500g" }, 
      { :name => "your additional ingredient", :quantity => "quantity" }
    ]
  end
end
