window.switchSidebar = (data, callback) ->
  rightHaupt = $(".right-haupt")
  if rightHaupt.data("status") == "open"
    rightHaupt.animate
      "right": "-392px",
      300,
      ->
        if(callback != undefined && typeof callback == 'function') 
          callback(data)
    rightHaupt.data "status", "closed"
    $('#toggle_sidebar').delay(300).queue ->
      $(this).addClass("closed")
      $(this).dequeue()
  else
    rightHaupt.animate
      "right": "0px",
      300
    rightHaupt.data "status", "open"
    $('#toggle_sidebar').delay(300).queue ->
      $(this).removeClass("closed")
      $(this).dequeue()


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



  


