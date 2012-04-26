$ = jQuery

publicMethods =
  init: (checkPointCharlie) ->
    this.each ->
      element = $(this)

      $(window).scroll (event) ->
        if $(window).scrollTop() >= checkPointCharlie.position().top
          element.stop(true, true).fadeIn 500
        else
          element.stop(true, true).fadeOut 500

  destroy: ->
    this.each ->
      $(window).unbind "scroll"

$.fn.visibleAfter = (method) ->
  if publicMethods[method]
    publicMethods[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is "object" or not method
    publicMethods.init.apply this, arguments
  else
    $.error "Method " +  method + " does not exist on jQuery.visibleAfter"