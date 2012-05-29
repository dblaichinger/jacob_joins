window.initInfobox = ->
  Gmaps.map.infobox = (boxText) ->
    content: boxText
    disableAutoPan: false
    maxWidth: 0
    pixelOffset: new google.maps.Size(-140, 0)
    zIndex: null
    boxStyle:
      background: "url('/assets/tipbox.png') no-repeat"
      opacity: 0.95

    closeBoxMargin: "10px 2px 2px 2px"
    closeBoxURL: "/assets/close.png"
    infoBoxClearance: new google.maps.Size(1, 1)
    isHidden: false
    pane: "floatPane"
    enableEventPropagation: false

window.initClusterer = ->
  Gmaps.map.customClusterer = ->
    url = "/assets/"
    [
      textColor: "#531E09"
      textSize: 12
      fontFamily: "Sanches-SemiBold"
      anchorIcon: [60, 30]
      anchor: [13, 26]
      url: url + "sammelmarker3.png"
      width: 60
      height: 60
    ,
      textColor: "#531E09"
      textSize: 18
      fontFamily: "Sanches-SemiBold"
      anchorIcon: [75, 37]
      anchor: [16, 26]
      url: url + "sammelmarker2.png"
      height: 75
      width: 75
    ,
      textColor: "#531E09"
      fontFamily: "Sanches-SemiBold"
      anchorIcon: [90, 45]
      url: url + "sammelmarker1.png"
      height: 90
      width: 90
    ]