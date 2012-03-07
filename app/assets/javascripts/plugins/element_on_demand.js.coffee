$ = jQuery

bindKeyDownIfConfigured = (activated, element) ->
  if activated
    last_input = $("input[type='text'], textarea", element).last()

    if not last_input
      return $.error "onKeyDown was activated, but no input field exists"

    last_input.bind "keydown.elementOnDemand", keyDownHandler

appendAddButton = (parent) ->
  button = $("<img id='add' src='/assets/add_icon.png' />").appendTo parent
  button.bind "click.elementOnDemand", clickHandler

removeAddButton = ->
  $("#add").unbind ".elementOnDemand"
  $("#add").remove()

clickHandler= ->
  $.fn.elementOnDemand "addElement", $("input[type='text'], textarea", $(".dynamicElement").last()).last()

keyDownHandler = (event) ->
  if event.which is 9
    $.fn.elementOnDemand "addElement", $(this)

publicMethods =
  init: (options) ->
    this.each ->
      data = $(this).data "elementOnDemand"

      if not data
        settings = $.extend
          onKeyDown: true
          element: $("<div>").append($(".dynamicElement").last().clone()).html()
        , options

        $(this).data "elementOnDemand", settings
        appendAddButton $(this)
        bindKeyDownIfConfigured settings.onKeyDown, $(".dynamicElement", $(this)).last()

  destroy: ->
    this.each ->
      data = $(this).data "elementOnDemand"

      $(window).unbind ".elementOnDemand"
      $(this).removeData "elementOnDemand"

  addElement: (last_element) ->
    container = $(".dynamicElement").parent()
    data = container.data "elementOnDemand"

    removeAddButton()
    $(last_element).unbind("keydown.elementOnDemand")

    new_element = $(data.element).appendTo container
    appendAddButton container

    element_count = container.children(".dynamicElement").size()

    new_element.children("[id]").each ->
      $(this).prop
        id: $(this).prop("id") + "_" + element_count

    bindKeyDownIfConfigured data.onKeyDown, new_element

$.fn.elementOnDemand = (method) ->
  if publicMethods[method]
    publicMethods[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is "object" or not method
    publicMethods.init.apply this, arguments
  else
    $.error "Method " +  method + " does not exist on jQuery.elementOnDemand"