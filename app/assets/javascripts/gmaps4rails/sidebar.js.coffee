window.switchSidebar = ->
  if $("#right-haupt").css("margin-right") is "0px"
    $("#right-haupt").animate
      "margin-right": "-400px",
      300
  else
    $("#right-haupt").animate
      "margin-right": "0px",
      300

window.showRecipeSidebar = (marker) ->
  $.ajax 
    url: "/recipes/getSidebar"
    dataType: "text"
    success: (data, textStatus, jqXHR) ->
      console.debug(data)
      #switchSidebar()
      replaceSidebar(data, marker)
    error: (jqXHR, textStatus, errorThrown) ->
      console.debug(jqXHR)
      console.debug(textStatus)
      console.debug(errorThrown)

window.replaceSidebar = (newHtml, marker) ->
  #console.debug(marker)
  #alert("replace")
  $('.right-haupt').replaceWith(newHtml)

  output = ""
  $.each marker.description,(index, value)->
    output += "<p>"+value+"</p>"

  $('#search_result').html(output)
  $('.right-haupt').css 'min-height', $(document).height()+"px"
  $('.seitenleiste').css 'min-height', $(document).height()+"px"
  #switchSidebar()
