$ = jQuery

bindKeyUpIfConfigured = (activated, element) ->
  if activated
    last_input = $("input[type='text'], textarea", element).last()

    if not last_input
      return $.error "onKeyUp was activated, but no input field exists"

    last_input.bind "keyup.elementOnDemand", keyUpHandler

appendAddButton = (parent) ->
  button = $("<img id='add' src='/assets/add_icon.png' />").appendTo parent
  button.bind "click.elementOnDemand", clickHandler

removeAddButton = ->
  $("#add").unbind ".elementOnDemand"
  $("#add").remove()

clickHandler= ->
  $.fn.elementOnDemand "addElement", $("input[type='text'], textarea", $(".dynamicElement").last()).last()

keyUpHandler = (event) ->
  if event.which is 13 and event.ctrlKey is true
    $.fn.elementOnDemand "addElement", $(this)

publicMethods =
  init: (options) ->
    this.each ->
      data = $(this).data "elementOnDemand"

      if not data
        settings = $.extend
          onKeyUp: true
          element: $(this).html()
        , options

        $(this).data "elementOnDemand", settings
        appendAddButton $(this)
        bindKeyUpIfConfigured settings.onKeyUp, $(".dynamicElement", $(this)).first()

  destroy: ->
    this.each ->
      data = $(this).data "elementOnDemand"

      $(window).unbind ".elementOnDemand"
      $(this).removeData "elementOnDemand"

  addElement: (last_element) ->
    container = $(".dynamicElement").parent()
    data = container.data "elementOnDemand"

    removeAddButton()
    $(last_element).unbind("keyup.elementOnDemand")
    new_element = $(data.element).appendTo container
    appendAddButton container

    element_count = container.children(".dynamicElement").size()

    new_element.children("[id]").each ->
      $(this).prop
        id: $(this).prop("id") + "_" + element_count

    bindKeyUpIfConfigured data.onKeyUp, new_element

$.fn.elementOnDemand = (method) ->
  if publicMethods[method]
    publicMethods[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is "object" or not method
    publicMethods.init.apply this, arguments
  else
    $.error "Method " +  method + " does not exist on jQuery.elementOnDemand"