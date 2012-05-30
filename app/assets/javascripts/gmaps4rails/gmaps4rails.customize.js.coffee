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
      textSize: 10
      anchor: [14, 19]
      url: url + "sammelmarker3.png"
      width: 60
      height: 60
    ]

window.initCustomMapStyles = ->
  customMapStyles = [
    {
      featureType: "all",
      stylers: [
        { saturation: -80 }
      ]
    },
    {
      featureType: "poi.park",
      stylers: [
        { hue: "#ff0023" },
        { saturation: 40 }
      ]
    }
  ];