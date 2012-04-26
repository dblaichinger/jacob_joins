Recipe = (title, portions, duration, ingredients) ->
  window.title = ko.observable title
  window.portions = ko.observable portions
  window.duration = ko.observable duration
  window.ingredients = ko.observableArray ingredients

  window.addIngredient = ->
    window.ingredients.push { name : ko.observable(""), quantity : ko.observable("") }

  window.removeIngredient = (ingredient) ->
    window.ingredients.pop() if window.ingredients().length > 1

$ ->
  ko.applyBindings new Recipe "", "", "", [ {name : "Eggs"}, {name : "Onion"}, {name : "Potatoes"} ]