window.initInfobox = ->
  Gmaps.map.infobox = (boxText) ->
    content: boxText
    disableAutoPan: false
    maxWidth: 0
    pixelOffset: new google.maps.Size(-140, 0)
    zIndex: null
    boxStyle:
      background: "url('http://google-maps-utility-library-v3.googlecode.com/svn/tags/infobox/1.1.5/examples/tipbox.gif') no-repeat"
      opacity: 0.75
      width: "280px"

    closeBoxMargin: "10px 2px 2px 2px"
    closeBoxURL: "http://www.google.com/intl/en_us/mapfiles/close.gif"
    infoBoxClearance: new google.maps.Size(1, 1)
    isHidden: false
    pane: "floatPane"
    enableEventPropagation: false

window.initClusterer = ->
  Gmaps.map.customClusterer = ->
    url = "http://gmaps-utility-library.googlecode.com/svn/trunk/markerclusterer/1.0/images/"
    [
      url: url + "heart30.png"
      height: 26
      width: 30
    ,
      url: url + "heart40.png"
      height: 35
      width: 40
    ,
      url: url + "heart50.png"
      width: 50
      height: 44
     ]