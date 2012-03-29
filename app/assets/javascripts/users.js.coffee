window.publish_user = ->
  return_value = false

  $.ajax
    url: "users/draft"
    type: "POST"
    data: { _method: "PUT" }
    async: false
    success: (data, textStatus, jqXHR) -> 
      return_value = data
    statusCode:
      400: ->
        return_value = false
      500: ->
        return_value = false

  return return_value

initialize = ->
  mapOptions = 
    center: new google.maps.LatLng(47.791136, 13.036877) # lat and lng of salzburg
    zoom: 10
    mapTypeId: google.maps.MapTypeId.TERRAIN # ROADMAP is normal map

  map = new google.maps.Map($('#user_tab .map')[0], mapOptions)
  input = $('#user_tab .address-search')[0]
  autocomplete = new google.maps.places.Autocomplete(input)

  autocomplete.bindTo('bounds', map)

  infowindow = new google.maps.InfoWindow()
  marker = new google.maps.Marker
    map: map

  google.maps.event.addListener autocomplete, 'place_changed', ->
    infowindow.close()
    place = autocomplete.getPlace()
    if place.geometry.viewport
      map.fitBounds place.geometry.viewport
    else
      map.setCenter place.geometry.location
      map.setZoom 17

    image = new google.maps.MarkerImage place.icon, new google.maps.Size(71, 71), new google.maps.Point(0, 0), new google.maps.Point(17, 34), new google.maps.Size(35, 35)
    marker.setIcon image
    marker.setPosition place.geometry.location

    address = ''
    if place.address_components
      address = [
        (place.address_components[0] && place.address_components[0].short_name || ''),
        (place.address_components[1] && place.address_components[1].short_name || ''),
        (place.address_components[2] && place.address_components[2].short_name || '')
      ].join(' ')

    infowindow.setContent '<div><strong>' + place.name + '</strong><br>' + address
    infowindow.open map, marker

    autocomplete.setTypes []

    #setupClickListener('changetype-all', []);
    #setupClickListener('changetype-establishment', ['establishment']);
    #setupClickListener('changetype-geocode', ['geocode']);

google.maps.event.addDomListener window, 'load', initialize
