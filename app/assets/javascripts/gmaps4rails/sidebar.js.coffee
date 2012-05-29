window.switchSidebar = (data, callback) ->
  rightHaupt = $(".right-haupt")
  toggleSidebar = $('#toggle_sidebar')
  if rightHaupt.data("status") is "closed"
    rightHaupt.animate
      "right": "-397px",
      'fast'
    .animate
      "right": "0px",
      600
      ->
        toggleSidebar.removeClass("closed")
      
    rightHaupt.data "status", "open"

  else
    rightHaupt.animate
      "right": "5px"
    .animate
      "right": "-392px",
      600
      ->
        if(callback != undefined && typeof callback == 'function') 
          callback(data)
        toggleSidebar.addClass("closed")

    rightHaupt.data "status", "closed"

window.showRecipeSidebar = (marker) ->
  if $(".right-haupt").data("status") == "open"
    switchSidebar(marker, getSidebar)
  else
    getSidebar(marker)

window.getSidebar = (marker) ->
  $.ajax 
    url: "/recipes/getSidebar"
    dataType: "text"

    success: (data, textStatus, jqXHR) ->
      $('.seitenleistecontent').html(data)
      console.debug(marker)

      if marker.length > 1
        $.each marker, (index, m) -> 
          $(m.description).appendTo $('#search_result')
      else
        $('#search_result').html(marker.description)

    error: (jqXHR, textStatus, errorThrown) ->
      console.debug(jqXHR)
      console.debug(textStatus)
      console.debug(errorThrown)

    complete: ->
      if $(".right-haupt").data("status") == "closed"
        switchSidebar()

window.positionToggleSidebar = (fadeIn) ->
  $('#toggle_sidebar').css('top', (($(document).height()/2)-45+"px"))
  if fadeIn
    $('#toggle_sidebar').fadeIn(1500)
  else
    $('#toggle_sidebar').show()

window.initSidebar = ->
  $("#toggle_sidebar").click ->
    switchSidebar()
    false
  $('.right-haupt').data "status", "open"
  


