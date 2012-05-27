window.switchSidebar = ->
  if $(".right-haupt").css("right") is "0px"
    $(".right-haupt").animate
      "right": "-392px",
      300
  else
    $(".right-haupt").animate
      "right": "0px",
      300

window.showRecipeSidebar = (marker) ->
  console.debug(marker)


  $.ajax 
    url: "/recipes/getSidebar"
    data: {"marker": marker.description, "type": "getSearchSidebar"}
    dataType: "json"
    type: "GET"
    success: (data, textStatus, jqXHR) ->
      console.debug(data)
    error: (jqXHR, textStatus, errorThrown) ->
      console.debug(errorThrown)


#Gmaps4RailsGoogle.event.addListener marker, "click", ->
#  alert "works"
