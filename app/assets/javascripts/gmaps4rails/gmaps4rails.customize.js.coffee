# Set eventlistener for Marker
window.initMarkerEventListener = ->
  i = 0

  while i < Gmaps.map.markers.length
    marker = Gmaps.map.markers[i].serviceObject
    marker.description = Gmaps.map.markers[i].description
    google.maps.event.addListener marker, "click", (i) ->
      if Path.routes.current is "/recipes/search" or Path.routes.current is "#/recipes/search"
        showRecipeSidebar this
      else
        $("body").data "selected_map_markers", this
        Path.history.pushState {}, "", "/recipes/search"
    ++i

# Set eventlistener for MarkerCluster
window.initClusterEventListener = ->
  markerClusterer = Gmaps.map.markerClusterer
  google.maps.event.addListener markerClusterer, "clusterclick", (cluster) ->
    markers = cluster.getMarkers()
    if Path.routes.current is "/recipes/search" or Path.routes.current is "#/recipes/search"
      showRecipeSidebar markers
    else
      $("body").data "selected_map_markers", markers
      Path.history.pushState {}, "", "/recipes/search"

window.initInfobox = ->
  Gmaps.map.infobox = (boxText) ->
    content: boxText
    disableAutoPan: false
    maxWidth: 0
    pixelOffset: new google.maps.Size(-169, 0)
    zIndex: null
    boxStyle:
      background: "url('/assets/tipbox.png') no-repeat"
      opacity: 0.95

    closeBoxMargin: "10px 2px 2px 2px"
    closeBoxURL: "/assets/infobox_close.png"
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

window.initCustomMapStyles = ->
  customMapStyles = [
      {
      featureType: "water"
      stylers: [
        {hue: "#531E09"},
        {saturation: -70}
      ]
      },
      {
      featureType: "landscape.man_made"
      stylers: [
        {hue: "#531E09"}
      ]
      },
      {
      featureType: "poi.park"
      stylers: [
        {hue: "#531E09"},
        {saturation: -80},
        {lightness: 50},
        {gamma: 0.3}
      ]
      },
      {
      featureType: "administrative"
      stylers: [
        {hue: "#531E09"},
        {saturation: 0},
        {gamma: 2.0}
      ]
      },
      {
      featureType: "administrative.province"
      stylers: [
        {hue: "#531E09"},
        {saturation: 0},
        {gamma: 0.8}
      ]
      },
      {
      featureType: "poi"
      stylers: [
        {visibility: "off"},
      ]
      },
      {
      featureType: "landscape"
      stylers: [
        {visibility: "off"},
      ]
      },
      {
      featureType: "road"
      stylers: [
        {hue: "#531E09"},
        {saturation: -90},
        {gamma: 2.8}
      ]
      },
      {
      featureType: "transit"
      stylers: [
        {visibility: "off"},
      ]
      }
  ];

window.initCustomMarkers = (markers) ->
  $.each markers, (key, m) ->
    m.picture = "/assets/google_marker_small.png"
    m.width = 30
    m.height = 50
