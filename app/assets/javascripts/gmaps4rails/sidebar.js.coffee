window.switchSidebar = (data, callback) ->
  if $(".right-haupt").data("status") == "open"
    $(".right-haupt").animate
      "right": "-400px",
      300,
      ->
        if(callback != undefined && typeof callback == 'function') 
          callback(data)
    $("#toggle_sidebar").css("background-position", "0px 40px")
    $(".right-haupt").data "status", "closed"
  else
    $(".right-haupt").animate
      "right": "0px",
      300
    
    $("#toggle_sidebar").css("background-position", "0px 0px")
    $(".right-haupt").data "status", "open"


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
      $('.seitenleistecontent').replaceWith(data)
      if marker.length > 1
        $.each marker, (index, m) -> 
          $(m.description).appendTo $('#search_result')
      else
        $('#search_result').html(marker.description)

      initSidebar()


    error: (jqXHR, textStatus, errorThrown) ->
      console.debug(jqXHR)
      console.debug(textStatus)
      console.debug(errorThrown)

    complete: ->
      if $(".right-haupt").data("status") == "closed"
        switchSidebar()


window.initSidebar = (fadeIn)->
  $('#toggle_sidebar').css('top', (($(document).height()/2)-25+"px"))
  if fadeIn
    $('#toggle_sidebar').fadeIn(1500)
  else
    $('#toggle_sidebar').show()

  $("#toggle_sidebar").click ->
    switchSidebar()
  


