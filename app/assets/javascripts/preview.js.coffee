Recipe = (cook, title, portions, duration, ingredients, steps) ->
  window.cook = ko.observable cook
  window.title = ko.observable title
  window.portions = ko.observable portions
  window.duration = ko.observable duration
  window.ingredients = ko.observableArray ko.utils.arrayMap(ingredients, (ingredient) -> { name: ko.observable(ingredient.name), quantity: ko.observable(ingredient.quantity)} )
  window.steps = ko.observableArray ko.utils.arrayMap(steps, (step) -> { description: ko.observable(step.description)} )

  window.formattedDuration = ko.computed
    read: ->
      window.duration() + " min"

  window.addStep = ->
    window.steps.push { description : ko.observable("") }

  window.removeStep = (step) ->
    window.steps.pop() if window.steps().length > 1

  window.addIngredient = ->
    window.ingredients.push { name : ko.observable(""), quantity : ko.observable("") }

  window.removeIngredient = (ingredient) ->
    window.ingredients.pop() if window.ingredients().length > 1

$ ->
  ko.applyBindings new Recipe "", "", "", "", [ {name : "Eggs"}, {name : "Onion"}, {name : "Potatoes"} ], [ {description : ""} ]