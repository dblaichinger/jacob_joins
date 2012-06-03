window.switchSidebar = (data, callback) ->
  rightHaupt = $(".right-haupt")
  toggleSidebar = $('#toggle_sidebar')
  if rightHaupt.data("status") is "open"
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
  else
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

window.showRecipeSidebar = (marker) ->
  if $(".right-haupt").data("sidebar") == "info"
    if $(".right-haupt").data("status") == "closed"
      getSidebar(marker)
    else
      switchSidebar(marker, getSidebar)
  else if $(".right-haupt").data("status") == "open"
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
        if($('#recipe_number').length > 0)
           $('#recipe_number').html("<p>Number of recipes: "+marker.length+"</p>")
        else
          $('#search_result').prepend("<div id='recipe_number'><p>Number of recipes: "+marker.length+"</p></div>")
        $.each marker, (index, m) -> 
          description = $(m.description)
          $('a', description).attr('onclick', '')
          description.appendTo $('.paginationContent')

        if marker.length > 10
          $('#search_result').pajinate(paginationSettings)
      else
        description = $(marker.description)
        $('a', description).attr('onclick', '')
        $('.paginationContent').html(description)

    error: (jqXHR, textStatus, errorThrown) ->
      ajaxError.dialog('open')
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
  $('.parent-or-window-sensitive').css('min-height', '100%').each ->
    parentMinHeight = $(this).parent().css('min-height')
    parentHeight = $(this).parent().height()
    $(this).css 'min-height', parentHeight

window.paginationSettings = {
  items_per_page: 10,
  item_container_id: '.paginationContent'
  num_page_links_to_display: 10,
  nav_label_first: 'first',
  nav_label_last: 'last',
  nav_label_prev: '<',
  nav_label_next: '>'
}
