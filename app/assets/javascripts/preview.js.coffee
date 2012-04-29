$ ->
  window.recipe =
    cook: ""
    name: ""
    duration: ""
    portions: ""
    ingredients: []

  $("#new_user").link recipe,
    cook: "user[firstname]"

  $("#new_recipe").link recipe,
    name: "recipe[name]"
    duration: "recipe[duration]"
    portions: "recipe[portions]"
    ingredients:
      name: "recipe[ingredients_name]"
      convert: (value, source, target) ->
        i = $("[name='recipe[ingredients_name]']").index $(source)
        recipe.ingredients[i] = value