# source: http://craigsworks.com/projects/qtip2/demos/#growl

$ ->
  timer = (event) ->
    api = $(this).data("qtip")
    lifespan = 5000
    return  if api.get("show.persistent") is true
    clearTimeout api.timer
    api.timer = setTimeout(api.hide, lifespan)  if event.type isnt "mouseover"

  $.createGrowl = (message, title = "Attention!", persistent = true) ->
    target = $(".qtip.jgrowl:visible:last")
    $(document.body).qtip(
      content:
        text: message
        title:
          text: title
          button: true

      position:
        my: "bottom right"
        at: (if target.length then "top" else "bottom") + " right"
        target: (if target.length then target else $(window))
        adjust:
          y: -25
          x: (if target.length then -5 else -15)

        effect: (api, newPos) ->
          $(this).animate newPos,
            duration: 200
            queue: false

          api.cache.finalPos = newPos

      show:
        event: false
        ready: true
        effect: ->
          $(this).stop(0, 1).fadeIn 400, ->
            updateGrowls()

        delay: 0
        persistent: persistent

      hide:
        event: false
        effect: (api) ->
          $(this).stop(0, 1).fadeOut(400).queue ->
            api.destroy()
            updateGrowls()

      style:
        classes: "jgrowl ui-tooltip-dark ui-tooltip-rounded"
        tip: false

      events:
        render: (event, api) ->
          timer.call api.elements.tooltip, event
    ).removeData "qtip"

  updateGrowls = ->
    each = $(".qtip.jgrowl")
    width = each.outerWidth()
    height = each.outerHeight()
    gap = each.eq(0).qtip("option", "position.adjust.y")
    pos = undefined
    each.each (i) ->
      api = $(this).data("qtip")
      api.options.position.target = (if not i then $(window) else [ pos.left + $(this).outerWidth() + 5, pos.top ])
      api.set "position.at", (if not i then "bottom" else "top") + " right"
      api.set "position.adjust.x", (if not i then -15 else -5)
      pos = api.cache.finalPos

  $(window).resize (e) ->
    updateGrowls()

  $(document).delegate ".qtip.jgrowl", "mouseover mouseout", timer