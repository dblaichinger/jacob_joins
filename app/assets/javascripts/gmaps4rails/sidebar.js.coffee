window.switchSidebar = (data, callback) ->
  if $(".right-haupt").data("status") == "open"
    $(".right-haupt").animate
      "right": "-392px",
      300,
      ->
        if(callback != undefined && typeof callback == 'function') 
          callback(data)
    $(".right-haupt").data "status", "closed"
  else
    $(".right-haupt").animate
      "right": "0px",
      300
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
      $('.seitenleiste').replaceWith(data)
      console.debug(marker)
      if marker.length > 1
        $.each marker, (index, m) -> 
          $(m.description).appendTo $('#search_result')
      else
        $('#search_result').html(marker.description)

      $('.right-haupt').css 'min-height', $(document).height()+"px"
      $('.seitenleiste').css 'min-height', $(document).height()+"px"

    error: (jqXHR, textStatus, errorThrown) ->
      console.debug(jqXHR)
      console.debug(textStatus)
      console.debug(errorThrown)

    complete: ->
      if $(".right-haupt").data("status") == "closed"
        switchSidebar()



  


