$ = jQuery

fancyStoryScrollHandler = (e) ->
  container = e.data.pluginElement
  remainingPixel = $(window).scrollTop()

  container.children('li').each (i, e) ->
    e = $(e)
    remainingPixel -= e.height()

    if remainingPixel > 0
      e.css
        top: '-' + e.height() + 'px'
    else if remainingPixel + e.height() > 0
      e.css
        top: '-' + (e.height() + remainingPixel) + 'px'
    else
      e.css
        top: 0

fancyStoryResizeHandler = (e) ->
  prepareStories($(e.data.pluginElement), e.data.settings)
  $(window).scroll()
  

prepareStories = (container, settings) ->
  windowHeight = $(window).height()
  windowWidth = $(window).width()
  lisHeight = 0

  childLis = container.children('li')

  childLis.each (index, currentLi) ->
    currentLi = $(currentLi)
    divsInLi = currentLi.children('div')

    $(divsInLi[0]).css
      height: 'auto'

    #footbridgeHeight = if divsInLi[1] then $(divsInLi[1]).height() else 0
    footbridgeHeight = 0
    storyHeight = if (windowHeight - footbridgeHeight) < currentLi.height() then currentLi.height() else windowHeight - footbridgeHeight

    $(divsInLi[0]).css
      height: storyHeight

    currentLi.css
      position: 'fixed'
      width: windowWidth
      zIndex: settings.firstZIndex + childLis.length - index - 1

    lisHeight += currentLi.height()

  container.height(lisHeight)

  if window.location.hash is "#skipstory" then window.location.hash = "#skipstory"


publicMethods =
  init: (options) ->
    this.each ->
      element = $(this)

      settings = $.extend(
        firstZIndex: 5
      , options)

      $(window).bind 'scroll.fancyStoryEffect',
        pluginElement: element
      , fancyStoryScrollHandler

      $(window).bind 'resize.fancyStoryEffect',
        pluginElement: element
        settings: settings
      , fancyStoryResizeHandler

      #TODO: handle window resize

      prepareStories(element, settings)

  scrollTo: (jqObject, time, options) ->
    this.each ->
      element = $(this)
      jqObject = $(jqObject) if typeof(jqObject) == "string"
      scrollPosition = 0

      element.children('li').each (i, e) ->
        console.log jqObject.has($(e)).length
        if $(e).has(jqObject).length
          return false
        else
          scrollPosition += $(e).height()

      $.scrollTo scrollPosition, time, options


  destroy: ->
    this.each ->
      $(window).unbind 'scroll.fancyStoryEffect'

$.fn.fancyStoryEffect = (method) ->
  if publicMethods[method]
    publicMethods[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is "object" or not method
    publicMethods.init.apply this, arguments
  else
    $.error "Method " +  method + " does not exist on jQuery.fancyStoryEffect"