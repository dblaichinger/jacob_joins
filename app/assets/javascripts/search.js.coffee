window.recipesSearch ||= {}

printResults = (data) ->
  unless data.ingredients.length is 0
    $.each data.ingredients, (key, ingredient) ->
      ingredient_exists = false
      $.each $("#search_hidden input:hidden"), (key, input) ->
        ingredient_exists = true if $(input).val() is ingredient

      unless ingredient_exists
        searchHidden = $("<input type='hidden' name='ingredients[]' value='" + ingredient + "' >").appendTo "#search_hidden"
        searchSelection = $("<p><a href='#' class='search_remove_ingredient'>remove ingredient</a>#{ingredient}</p>").appendTo "#search_selection"
        searchSelection.data('hidden', searchHidden)
        $('#ingredients_search').val("").focus()


    
    recipe_number = "<div id='recipe_number'><p>Number of recipes: #{data.recipes.length}</p></div>"
    $(".paginationContent").html recipe_number

    if data.recipes.length > 0
      output = ""
      $.each data.recipes, (key, recipe) ->
        if recipe?
          output += ("<div class='recipe_search_result'>
                      <div class='infobox_image'><a href='/recipes/#{recipe.slug}' class='recipe_link'><img src='#{recipe.image}' /></a></div>
                      <div class='infobox_recipe_text'>
                      <p class='infobox_recipe'><a href='/recipes/#{recipe.slug}'>#{recipe.name}</a></p>
                      <p class='infobox_author'>cooked by <em>#{recipe.user.firstname} #{recipe.user.lastname}</em>, #{recipe.country}</p>
                      <p class='infobox_duration'>Estimated cooking time: #{recipe.duration} minutes</p>
                      </div></div>")

      $(".paginationContent").append output
      $('#search_result').pajinate(paginationSettings)
      initCustomMarkers(data.markers)
      Gmaps.map.replaceMarkers(data.markers)
      #initMarkerEventListener()
      #initClusterEventListener()
      
    else
      $(".paginationContent").append "<p class='no_result_1'>No recipes found!</p><p class='no_result_2'>Please use the auto-complete function.</p>"
  else
    $(".paginationContent").html ""
    Gmaps.map.replaceMarkers([])

window.recipesSearch.ingredientsSearchSelectHandler = (event, ui) ->
  $(event.target).val(ui.item.value)
  $('#ingredients_search_form').submit()
  $(event.target).val("")
  false

window.recipesSearch.removeIngredientClickHandler = (e) ->
  searchEntry = $(e.target).parent()
  hiddenField = searchEntry.data('hidden')
  hiddenField.remove()
  searchEntry.addClass("pending")
  $('#ingredients_search_form').submit()
  false

window.recipesSearch.formSuccessHandler = (evt, data, status, xhr) ->
  printResults(data)
  $("#search_selection p.pending").remove()

window.recipesSearch.formErrorHandler = (evt, xhr, status, error) ->
  console.log("Cannot find any ingredient due to the following reason: "+error)
  $("#search_selection p.pending").each (e) ->
    $('#search_hidden').append $(e).data('hidden')

window.removeAutoComplete = ->
  if $('.ui-menu-item').length > 0
    $('.ui-menu-item').remove()
