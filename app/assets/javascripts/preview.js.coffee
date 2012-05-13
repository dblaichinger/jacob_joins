Recipe = (cook, title, portions, duration, ingredients, steps) ->
  window.cook = ko.observable cook
  window.title = ko.observable(title).extend {logChange: ""}
  window.portions = ko.observable portions
  window.duration = ko.observable duration
  window.ingredients = ko.observableArray(ko.utils.arrayMap(ingredients, (ingredient) -> { name: ko.observable(ingredient.name), quantity: ko.observable(ingredient.quantity)} )).extend {logChange: ""}
  window.steps = ko.observableArray ko.utils.arrayMap(steps, (step) -> { description: ko.observable(step.description)} )

  window.addStep = ->
    window.steps.push { description : ko.observable("") }

  window.removeStep = (step) ->
    window.steps.pop() if window.steps().length > 1

  window.addIngredient = ->
    window.ingredients.push { name : ko.observable(""), quantity : ko.observable("") }

  window.removeIngredient = (ingredient) ->
    window.ingredients.pop() if window.ingredients().length > 1

  window.afterRenderHandler = (elements, data) ->
    window.afterUpdate = new Date().getTime()

ko.bindingHandlers.yourBindingName =
  update: (element, valueAccessor, allBindingsAccessor, viewModel) ->
    ko.bindingHandlers.template.update element, valueAccessor, allBindingsAccessor, viewModel
    window.afterUpdate = new Date().getTime()

ko.extenders.logChange = (target, option) ->
  target.subscribe (newValue) ->
    window.beforeUpdate = new Date().getTime()
  target

$ ->
  ko.applyBindings new Recipe "", "", "", "", [ {name : "Eggs"}, {name : "Onion"}, {name : "Potatoes"} ], [ {description : ""} ]