$ ->
  window.recipe =
    cook: ""
    name: ""
    duration: ""
    portions: ""
    ingredients: []
    steps: []

  $("#new_user").link recipe,
    cook:
      name: "user[firstname]"
      convert: (value, source, target) ->
        $("#p_prev p:last").remove()
        markup = "<p>Cooked by: <em>${cook}</em></p>"
        $.tmpl(markup, { cook: value }).appendTo "#p_prev"
        value

  $("#new_recipe").link recipe,
    name:
      name: "recipe[name]"
      convert: (value, source, target) ->
        $("#prev_recipe_info h1").remove()
        markup = "<h1>${name}</h1>"
        $.tmpl(markup, { name: value }).prependTo "#prev_recipe_info"
        value
      convertBack: (value, source, target) ->
        window.beforeUpdate = new Date().getTime()
        value
    portions:
      name: "recipe[portions]"
      convert: (value, source, target) ->
        $("#p_prev p:first").remove()
        markup = "<p>Portions: <em>${portions}</em></p>"
        $.tmpl(markup, { portions: value }).prependTo "#p_prev"
        value
    duration:
      name: "recipe[duration]"
      convert: (value, source, target) ->
        $("#p_prev p:first").next().remove()
        markup = "<p>Preparation time: <em>${duration} minutes</em></p>"
        $.tmpl(markup, { duration: value }).insertAfter "#p_prev p:first"
        value
    ingredients:
      name: "recipe[ingredients]"
      convert: (value, source, target) ->
        if $(".zutat[name='recipe[ingredients]']").is source
          i = $(".zutat[name='recipe[ingredients]']").index source
          recipe.ingredients[i] = { name: "", quantity: "" } unless recipe.ingredients[i]
          recipe.ingredients[i].name = value
        else
          i = $(".menge[name='recipe[ingredients]']").index source
          recipe.ingredients[i] = { name: "", quantity: "" } unless recipe.ingredients[i]
          recipe.ingredients[i].quantity = value

        $("#prev_ingredients li").remove()
        markup = "<li><span>${quantity}</span><em>${name}</em></li>"
        $.tmpl(markup, recipe.ingredients).appendTo "#prev_ingredients ul"

        recipe.ingredients
      convertBack: (value, source, target) ->
    steps:
      name: "recipe[steps]"
      convert: (value, source, target) ->
        i = $("[name='recipe[steps]']").index source
        recipe.steps[i] = { description: "", stepCount: "" } unless recipe.steps[i]
        recipe.steps[i].description = value
        recipe.steps[i].stepCount = i + 1

        $(".prev_preparatoin_step").remove()
        markup = "<div class='prev_preparatoin_step'><p><em>Step ${stepCount}</em><br/>${description}</p></div>"
        $.tmpl(markup, recipe.steps).insertAfter "#prev_preparation h2"

        recipe.steps
      convertBack: (value, source, target) ->

  $("#ingredients .add").click (event) ->
    markup = "<p class='dynamicElement'><input class='menge' name='recipe[ingredients]' placeholder='quantity' size='30' type='text'><input class='zutat' name='recipe[ingredients]' placeholder='your additional ingredient' size='30' type='text'></p>";
    $(markup).insertAfter "#ingredients .dynamicElement:last"

  $("#ingredients .remove").click (event) ->
    if $("#ingredients .dynamicElement").size() == 1
      return false

    $("#ingredients .dynamicElement:last").remove()
    recipe.ingredients.pop()

  $(".steps .add").click (event) ->
    markup = "<div class='step dynamicElement'><label class='step_label'>Step ${count}</label><textarea cols='40' name='recipe[steps]' rows='20'></textarea></div>
"
    $.tmpl(markup, { count: recipe.steps.length+1 }).insertAfter ".steps .dynamicElement:last"

  $(".steps .remove").click (event) ->
    if $(".steps .dynamicElement").size() == 1
      return false

    $(".steps .dynamicElement:last").remove()
    recipe.steps.pop()