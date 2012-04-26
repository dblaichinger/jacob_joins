$ = jQuery

publicMethods =
  init: (checkPointCharlie) ->
    this.each ->
      element = $(this)

      $(window).scroll (event) ->
        if $(window).scrollTop() >= checkPointCharlie.position().top
          element.fadeIn 500, ->
            $(this).stop true, true
        else
          element.fadeOut 500, ->
            $(this).stop true, true

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