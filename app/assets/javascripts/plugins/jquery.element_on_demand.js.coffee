$ = jQuery

bindKeyDownIfConfigured = (activated, element) ->
  if activated
    last_input = $(":input[type='text'], textarea", element).last()

    if not last_input
      return $.error "onKeyDown was activated, but no input field exists"

    last_input.bind "keydown.elementOnDemand", keyDownHandler

appendButtons = (parent) ->
  addButton = $("<img class='add' src='/assets/add_icon.png' />").appendTo parent
  addButton.bind "click.elementOnDemand", clickAddHandler
  removeButton = $("<img class='remove' src='/assets/delete_icon.png' />").appendTo parent
  removeButton.bind "click.elementOnDemand", clickDeleteHandler

revomeButtons = (container) ->
  $(".add", container).unbind(".elementOnDemand").remove()
  $(".remove", container).unbind(".elementOnDemand").remove()

clickAddHandler = ->
  $.fn.elementOnDemand "addElement", $("input[type='text'], textarea", $(".dynamicElement", $(this).parent()).last()).last(), $(this).parent()

clickDeleteHandler = ->
  $.fn.elementOnDemand "removeElement", $("input[type='text'], textarea", $(".dynamicElement", $(this).parent()).last()).last(), $(this).parent()

keyDownHandler = (event) ->
  if event.which is 9
    $.fn.elementOnDemand("addElement", $("input[type='text'], textarea", $(this).parents('.dynamicElement').last()).last(), $(this).parents('.dynamicElement').parent())

publicMethods =
  init: (options) ->
    this.each ->
      data = $(this).data "elementOnDemand"

      if not data
        settings = $.extend
          onKeyDown: true
          element: $("<div>").append($(".dynamicElement", this).last().clone()).html()
          onAddElement: ->
          onRemoveElement: ->
        , options
        $(this).data "elementOnDemand", settings
        appendButtons $(this)
        bindKeyDownIfConfigured settings.onKeyDown, $(".dynamicElement", this).last()

  destroy: ->
    this.each ->
      data = $(this).data "elementOnDemand"

      $(window).unbind ".elementOnDemand"
      $(this).removeData "elementOnDemand"

  addElement: (last_element, container) ->
    data = container.data "elementOnDemand"
    revomeButtons(container)
    $(last_element).unbind("keydown.elementOnDemand")
    new_element = $(data.element).appendTo container
    appendButtons container

    element_count = container.children(".dynamicElement", this).size()

    new_element.find("[id][name]").each ->
      $(this).prop
        id: $(this).prop("id") + "_" + element_count
        name: $(this).prop("name").replace /[0-9]/, element_count - 1

    bindKeyDownIfConfigured data.onKeyDown, new_element
    container.trigger 'addElement.elementOnDemand', new_element
    data.onAddElement.call new_element

  removeElement: (last_element, container) ->
    if $(".dynamicElement", container).size() > 1
      data = $(".dynamicElement", container).parent().data "elementOnDemand"
      previous_element = $(".dynamicElement", container).last().prev()

      bindKeyDownIfConfigured data.onKeyDown, previous_element
      deleted_element = $(last_element).parent().remove()
      container.trigger 'removeElement.elementOnDemand'
      data.onRemoveElement.call deleted_element

$.fn.elementOnDemand = (method) ->
  if publicMethods[method]
    publicMethods[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is "object" or not method
    publicMethods.init.apply this, arguments
  else
    $.error "Method " +  method + " does not exist on jQuery.elementOnDemand"