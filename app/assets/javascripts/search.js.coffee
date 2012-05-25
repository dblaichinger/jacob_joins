window.recipesSearch ||= {}

window.recipesSearch.printResults = (data) ->
  unless data.ingredients.length is 0
    $.each data.ingredients, (key, ingredient) ->
      ingredient_exists = false
      $.each $("#search_hidden input:hidden"), (key, input) ->
        ingredient_exists = true  if $(input).attr("name") is "ingredients[" + ingredient + "]"

      unless ingredient_exists
        $("#search_hidden").append "<input type='hidden' name='ingredients[" + ingredient + "]' value='" + ingredient + "' >"
        $("#search_selection").append "<p>" + ingredient + "</p>"

    output = ""
    $.each data.recipes, (key, recipe) ->
      if recipe?
        output += ("<p>" + recipe._id + "</p>")
        output += ("<p>" + recipe.name + "</p>")

    $("#search_result").html output

window.recipesSearch.ingredientsSearchSelectHandler = (event, ui) ->
  console.log "select"
  console.log event
  console.log ui
  $(event.target).val(ui.item.value)
  $('#ingredients_search_form').submit()
  $(event.target).val("")
  false