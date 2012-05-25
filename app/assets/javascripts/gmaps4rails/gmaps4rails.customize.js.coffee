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
    url = "/assets/"
    [
      textColor: "#531E09"
      url: url + "sammelmarker1.png"
      height: 90
      width: 90
    ,
      textColor: "#531E09"
      textSize: 18
      anchor: [15, 27]
      url: url + "sammelmarker2.png"
      height: 75
      width: 75
    ,
      textColor: "#531E09"
      url: url + "sammelmarker3.png"
      width: 60
      height: 60
    ]