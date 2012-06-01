removeMapOverlay = (callback = ->) ->
  if (mapOverlay = $('.map-overlay')).length > 0
    $(window).unbind 'load', recipesShowWindowLoadHandler
    $(window).unbind 'resize', recipesShowWindowResizeHandler

    if $(window).width() <= 1400
      mapOverlay.fadeOut 300, ->
        mapOverlay.remove()
        callback()
    else
      mapOverlay.css
        right: "0px"
      .animate
        right: "-670px",
        300
        ->
          mapOverlay.remove()
          callback()
      $('.close-recipe.left').animate
        right: "-=670",
        opacity: "0"
        300

getSearchSidebar = (recipe_slug = "") ->
  if $('.right-haupt .seitenleistecontent .search').length == 0
    loadSearchBar = ->
      if $('body').data "initMapLayoutDone"
        switchSidebar '', ->
          $.ajax
            url: "/recipes/getSidebar"
            dataType: "text"
            data:
              id: recipe_slug

            success: (data, textStatus, jqXHR) ->
              $('.right-haupt .seitenleistecontent').html(data)

            error: (jqXHR, textStatus, errorThrown) ->
              console.debug(jqXHR)
              console.debug(textStatus)
              console.debug(errorThrown)

            complete: ->
              $('#sidebar_loader').hide()
              if $(".right-haupt").data("status") == "closed"
                $(".right-haupt").data("sidebar", "")
                switchSidebar()
      else
        window.setTimeout loadSearchBar, 100
    loadSearchBar()

recipesIndexController = () ->
  removeMapOverlay()
  switchSidebar '', ->
    $.ajax
      url: '/recipes'
      dataType: 'html'
      success: (data, textStatus, jqXHR) ->
        $('.right-haupt .seitenleistecontent').html(data)
      error: (jqXHR, textStatus, errorThrown) ->
        console.debug(jqXHR)
        console.debug(textStatus)
        consol
      complete: ->
        $('#sidebar_loader').hide()
        if $(".right-haupt").data("status") == "closed"
          $(".right-haupt").data("sidebar", "")
          switchSidebar()



Path.map("#!/:tab").to () ->
  $('#wizard').tabs 'select', '#' + this.params['tab']

Path.map("/").to () ->
  recipesIndexController()

Path.map("/recipes").to () ->
  recipesIndexController()

Path.map("/recipes/search").to () ->
  getSearchSidebar()
  removeMapOverlay() if ($('.map-overlay')).length > 0

Path.map("/recipes/:recipe_slug").to () ->
  route = this

  getSearchSidebar(route.params.recipe_slug)

  getRecipe = ->
    $.ajax
      url: '/recipes/' + route.params.recipe_slug
      dataType: 'html'
      success: (data, textStatus, jqXHR) ->
        $('#toggle_sidebar').before(data)
        recipesShowWindowLoadHandler()

        if $(window).width() <= 1400
          $('.map-overlay').hide().fadeIn 500
        else
          $('.map-overlay').css
            right: '-670px'
          .animate
            right: '0px',
            500

          $('.close-recipe.left').css
            right: '350px'
          .animate
            right: "1040px",
            500


      error: (jqXHR, textStatus, errorThrown) ->
        console.debug(jqXHR)
        console.debug(textStatus)
        console.debug(errorThrown)

  if $('.map-overlay').length > 0
    removeMapOverlay(getRecipe)
  else
    getRecipe()


$ ->
  __listen = Path.history.listen
  Path.history.listen = (fallback) ->
    __listen(fallback)
    Path.history.initial.popped = false if $.browser.webkit and parseFloat($.browser.version) >= 536.5

  Path.history.listen(true)

  if Path.history.supported
    window.location = window.location.hash.substr(1) if window.location.hash.substr(0, 2) == "#/"
  else
    window.location = "/#" + window.location.pathname if (window.location.pathname.substr(0, 8) == "/recipes" or window.location.pathname == "/") and not window.location.hash

  $('body').on 'click', 'a', (e) ->
    if (Path.routes.current == null or Path.routes.current == "") and !Path.history.supported
      return

    _t = href = $(e.target).attr('href').replace('http://'+window.location.host,'')
    _t = '#' + href unless Path.history.supported
    
    if href != undefined and Path.match(_t) != null
      e.preventDefault()
      Path.history.pushState({}, '', href)
      false

