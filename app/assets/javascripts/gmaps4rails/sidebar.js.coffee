window.switchSidebar = ->
  if $("#right-haupt").css("margin-right") is "0px"
    $("#right-haupt").animate
      "margin-right": "-400px",
      300
  else
    $("#right-haupt").animate
      "margin-right": "0px",
      300


#Gmaps4RailsGoogle.event.addListener marker, "click", ->
#  alert "works"
