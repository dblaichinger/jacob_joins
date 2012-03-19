module RecipesHelper
	def render_default_ingredient_fields_with(object)
    html = ""
    prefilled = object[0, object.length - 1]

    prefilled.each_index do |i|
      html << render(:partial => "recipes/ingredient_with_quantity", :locals => { :ingredient => prefilled[i][:ingredient], :quantity_placeholder => prefilled[i][:quantity], :ingredient_css_id => "recipe_ingredients_strings_ingredient_#{i}", :quantity_css_id => "recipe_ingredients_strings_quantity_#{i}"}).to_s
    end

    html << render(:partial => "recipes/ingredient_with_quantity", :locals => { :ingredient_placeholder => object.last[:ingredient], :quantity_placeholder => object.last[:quantity], :ingredient_css_id => "recipe_ingredients_strings_ingredient_#{object.length}", :quantity_css_id => "recipe_ingredients_strings_quantity_#{object.length}" }).to_s
  end

  def prefill_ingredient_fields_with(object)
    html = ""

    object.each_index do |i|
      html << render(:partial => "recipes/ingredient_with_quantity", :locals => { :ingredient => object[i][:ingredient], :quantity => object[i][:quantity], :ingredient_css_id => "recipe_ingredients_strings_ingredient_#{i}", :quantity_css_id => "recipe_ingredients_strings_quantity_#{i}" }).to_s
    end
  end
end
