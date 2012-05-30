window.switchSidebar = (data, callback) ->
  rightHaupt = $(".right-haupt")
  toggleSidebar = $('#toggle_sidebar')
  if rightHaupt.data("status") is "closed"
    rightHaupt.animate
      "right": "-397px",
      'fast'
    .animate
      "right": "0px",
      300

    toggleSidebar.animate
      "right": "-13px",
      "fast"
    .animate
      "right": "382px",
      300
      ->
        toggleSidebar.removeClass("closed")

    rightHaupt.data "status", "open"

  else
    rightHaupt.animate
      "right": "5px",
      "fast"
    .animate
      "right": "-392px",
      300
      ->
        if(callback != undefined && typeof callback == 'function') 
          callback(data)

    toggleSidebar.animate
      "right": "387px",
      'fast'
    .animate
      "right": "-8px",
      300
      ->
        toggleSidebar.addClass("closed")


    rightHaupt.data "status", "closed"

window.showRecipeSidebar = (marker) ->
  if $(".right-haupt").data("sidebar") == "info"
    switchSidebar(marker, getSidebar)
  else if $(".right-haupt").data("status") == "open"
    $('#sidebar_loader').fadeOut "fast"
    $('#sidebar_loader').show()
    getSidebar(marker)
  else
    switchSidebar(marker, getSidebar)


window.getSidebar = (marker) ->
  $.ajax
    url: "/recipes/getSidebar"
    dataType: "text"

    success: (data, textStatus, jqXHR) ->
      $('.seitenleistecontent').html(data)
      if marker.length > 1
        $('#search_result').html("<div id='recipe_number'><p>Number of recipes: "+marker.length+"</p></div>")
        $.each marker, (index, m) -> 
          $(m.description).appendTo $('#search_result')
      else
        $('#search_result').html(marker.description)

    error: (jqXHR, textStatus, errorThrown) ->
      console.debug(jqXHR)
      console.debug(textStatus)
      console.debug(errorThrown)

    complete: ->
      $('#sidebar_loader').hide()
      if $(".right-haupt").data("status") == "closed"
        $(".right-haupt").data("sidebar", "")
        switchSidebar()

window.positionVerticalCentered = (element, fadeIn) ->
  element.css 'top', ($(window).height() + 45 - element.height()) / 2
  if fadeIn
    element.fadeIn(1500)
  else
    element.show()

window.initSidebar = ->
  $("#toggle_sidebar").click ->
    switchSidebar()
    false
  $('.right-haupt').data "status", "open"

window.adjustParentOrWindowSensitiveElements = ->
  $('.parent-or-window-sensitive').each ->
    $(this).css 'min-height', '100%'
    parentMinHeight = $(this).parent().css('min-height')
    parentHeight = $(this).parent().height()
    $(this).css 'min-height', parentHeight

  


