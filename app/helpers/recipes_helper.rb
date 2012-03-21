module RecipesHelper
  def render_default_ingredient_fields(form, object)
    html = ""
    4.times { object.ingredients_with_quantities.build }
    object.ingredients_with_quantities = make_default_ingredients
    prefilled_fields = object.ingredients_with_quantities[0, object.ingredients_with_quantities.length - 1]
    
    prefilled_fields.each do |ingredient_with_quantity|
      html << render(:partial => "recipes/ingredient_with_quantity", :locals => { :form => form, :data => ingredient_with_quantity, :quantity_placeholder => ingredient_with_quantity.quantity, :ingredient => ingredient_with_quantity.name }).to_s
    end
    
    custom_ingredient = object.ingredients_with_quantities.last
    html << render(:partial => "recipes/ingredient_with_quantity", :locals => { :form => form, :data => custom_ingredient, :quantity_placeholder => custom_ingredient.quantity, :ingredient_placeholder => custom_ingredient.name }).to_s
  end

  def prefill_ingredient_fields(form, object)
    html = ""

    object.ingredients_with_quantities.each do |ingredient_with_quantity|
      html << render(:partial => "recipes/ingredient_with_quantity", :locals => { :form => form, :data => ingredient_with_quantity, :ingredient => ingredient_with_quantity.name, :quantity => ingredient_with_quantity.quantity}).to_s
    end

    html
  end

  private
  def make_default_ingredients
    [
      { :name => "Eggs", :quantity => "e.g.: 2 big" }, 
      { :name => "Onion", :quantity => "e.g.: 1 red" }, 
      { :name => "Potatoes", :quantity => "e.g.: 3" }, 
      { :name => "additional ingredient", :quantity => "enter the quantity" }
    ]
  end
end
