$ = jQuery

publicMethods =
  init: (checkPointCharlie, onAbove, onBeneath) ->
    this.each ->
      element = $(this)

      $(window).bind 'scroll.executeAt', (event) ->
        if $(window).scrollTop() >= (checkPointCharlie.position().top + checkPointCharlie.height())
          if onBeneath?
            onBeneath()
        else
          if onAbove?
            onAbove()

  destroy: ->
    this.each ->
      $(window).unbind "scroll.executeAt"

$.fn.executeAt = (method) ->
  if publicMethods[method]
    publicMethods[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is "object" or not method
    publicMethods.init.apply this, arguments
  else
    $.error "Method " +  method + " does not exist on jQuery.executeAt"