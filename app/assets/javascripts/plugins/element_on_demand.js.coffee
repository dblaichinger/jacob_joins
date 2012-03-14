$ = jQuery

bindKeyDownIfConfigured = (activated, element) ->
  if activated
    last_input = $("input[type='text'], textarea", element).last()

    if not last_input
      return $.error "onKeyDown was activated, but no input field exists"

    last_input.bind "keydown.elementOnDemand", keyDownHandler

appendButtons = (parent) ->
  addButton = $("<img id='add' src='/assets/add_icon.png' />").appendTo parent
  addButton.bind "click.elementOnDemand", clickAddHandler
  removeButton = $("<img id='remove' src='/assets/delete_icon.jpg' />").appendTo parent
  removeButton.bind "click.elementOnDemand", clickDeleteHandler

revomeButtons = ->
  $("#add").unbind ".elementOnDemand"
  $("#add").remove()
  $("#remove").unbind ".elementOnDemand"
  $("#remove").remove()

clickAddHandler= ->
  $.fn.elementOnDemand "addElement", $("input[type='text'], textarea", $(".dynamicElement").last()).last()

clickDeleteHandler= ->
  $.fn.elementOnDemand "removeElement", $("input[type='text'], textarea", $(".dynamicElement").last()).last()

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
        appendButtons $(this)
        bindKeyDownIfConfigured settings.onKeyDown, $(".dynamicElement", $(this)).last()

  destroy: ->
    this.each ->
      data = $(this).data "elementOnDemand"

      $(window).unbind ".elementOnDemand"
      $(this).removeData "elementOnDemand"

  addElement: (last_element) ->
    container = $(".dynamicElement").parent()
    data = container.data "elementOnDemand"

    revomeButtons()
    $(last_element).unbind("keydown.elementOnDemand")

    new_element = $(data.element).appendTo container
    appendButtons container

    element_count = container.children(".dynamicElement").size()

    new_element.children("[id]").each ->
      $(this).prop
        id: $(this).prop("id") + "_" + element_count

    bindKeyDownIfConfigured data.onKeyDown, new_element

  removeElement: (last_element) ->
    if $(".dynamicElement").size() > 1
      data = $(".dynamicElement").parent().data "elementOnDemand"
      previous_element = $(".dynamicElement").last().prev()

      bindKeyDownIfConfigured data.onKeyDown, previous_element
      $(last_element).parent().remove()

$.fn.elementOnDemand = (method) ->
  if publicMethods[method]
    publicMethods[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is "object" or not method
    publicMethods.init.apply this, arguments
  else
    $.error "Method " +  method + " does not exist on jQuery.elementOnDemand"