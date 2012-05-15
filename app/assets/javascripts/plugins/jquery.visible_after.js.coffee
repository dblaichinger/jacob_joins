$ = jQuery

publicMethods =
  init: (checkPointCharlie) ->
    this.each ->
      element = $(this)

      $(window).bind 'scroll.visibleAfter', (event) ->
        if $(window).scrollTop() >= (checkPointCharlie.position().top + checkPointCharlie.height())
          if element.is ":hidden"
            element.fadeIn 500
        else
          if element.is ":visible"
            element.fadeOut 500

  destroy: ->
    this.each ->
      $(window).unbind "scroll.visibleAfter"

$.fn.visibleAfter = (method) ->
  if publicMethods[method]
    publicMethods[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is "object" or not method
    publicMethods.init.apply this, arguments
  else
    $.error "Method " +  method + " does not exist on jQuery.visibleAfter"