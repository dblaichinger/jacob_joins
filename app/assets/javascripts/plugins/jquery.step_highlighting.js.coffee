$ = jQuery

clickHandler = (event) ->
  container = $(this).closest "form"
  $(".active[class|='part']", container).removeClass "active"
  $(".next[class|='part']", container).removeClass "next"
  $(this).addClass "active"
  current_part = $(this).prop("class").match(/(part-)[0-9]/)[0]
  next_part = current_part.replace /[0-9]/, parseInt(current_part[current_part.length - 1]) + 1

  if !!$("."+ next_part)
    $("."+ next_part).addClass "next"

publicMethods =
  init: ->
    this.each ->
      $("[class|='part']", $(this)).bind "click.stepHighlighting", clickHandler
      $(".part-1").trigger "click"

  destroy: ->
    this.each ->
      $(window).unbind ".stepHighlighting"

$.fn.stepHighlighting = (method) ->
  if publicMethods[method]
    publicMethods[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is "object" or not method
    publicMethods.init.apply this, arguments
  else
    $.error "Method " +  method + " does not exist on jQuery.stepHighlighting"