window.switchSidebar = (data, callback) ->
  if $(".right-haupt").data("status") == "open"
    $(".right-haupt").animate
      "right": "-400px",
      300,
      ->
        if(callback != undefined && typeof callback == 'function') 
          alert("callback1")
          callback(data)
    console.log("closing")
    $(".right-haupt").removeClass("sidebar_open").addClass("sidebar_closed") 
    $(".right-haupt").data "status", "closed"
  else
    $(".right-haupt").animate
      "right": "0px",
      2000, 
      ->
        if callback != undefined && typeof callback == 'function'
          alert("callback2")
          callback(data)
      console.log("opening")
    $(".right-haupt").removeClass("sidebar_closed").addClass("sidebar_open") 
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
      $('.right-haupt').replaceWith(data).addClass("sidebar_closed")
      $('#search_result').html(marker.description)
      $('.right-haupt').css 'min-height', $(document).height()+"px"
      $('.seitenleiste').css 'min-height', $(document).height()+"px"

    error: (jqXHR, textStatus, errorThrown) ->
      console.debug(jqXHR)
      console.debug(textStatus)
      console.debug(errorThrown)

    complete: ->
      if $(".right-haupt").data("status") == "closed"
        alert("openBLA")
        setTimeout("switchSidebar()", 2000)



  


