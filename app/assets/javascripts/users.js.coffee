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

window.prepare_user_map = ->
  map = new google.maps.Map $('#user_tab .map')[0],
    center: new google.maps.LatLng(47.806357, 13.039623) # lat and lng of salzburg
    zoom: 6
    mapTypeId: google.maps.MapTypeId.TERRAIN # ROADMAP is normal map
    mapTypeControl: false
    overviewMapControl: false
    panControl: false
    scaleControl: false
    streetViewControl: false
    zoomControl: false

  autoCompleteInput = $('#user_tab .address-search')
  autoCompleteInput.keydown (e) ->
    if e.which == 13
      e.preventDefault()
  autoCompleteInput.attr "data-valid", "false"
  autoCompleteInput.attr "data-error-message", "Location not found."

  autocomplete = new google.maps.places.Autocomplete autoCompleteInput[0], { types: ['(regions)'] }
  autocomplete.bindTo('bounds', map)

  marker = new google.maps.Marker
    map: map

  latInput = $('#latitude')
  lngInput = $('#longitude')
  cityInput = $('#city')
  countryInput = $('#country')

  setMarker = (latlng, imageUrl = "http://maps.gstatic.com/mapfiles/place_api/icons/geocode-71.png") ->
    map.setCenter latlng
    map.setZoom 8

    image = new google.maps.MarkerImage imageUrl, new google.maps.Size(71, 71), new google.maps.Point(0, 0), new google.maps.Point(17, 34), new google.maps.Size(35, 35)
    marker.setIcon image
    marker.setPosition latlng

  setHiddenFields = (lat, lng, city, country) ->
    latInput.val lat
    lngInput.val lng
    cityInput.val city
    countryInput.val country

  if !latInput.val() || !lngInput.val() || !cityInput.val() || !countryInput.val()
    # location via html5 geolocation
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(
        (position) ->
          latlng = new google.maps.LatLng position.coords.latitude, position.coords.longitude
          geocoder = new google.maps.Geocoder()

          geocoder.geocode {'latLng': latlng}, (results, status) -> 
            if status == google.maps.GeocoderStatus.OK
              objectnumber = results.length-4
              address = results[objectnumber].formatted_address

              address = address.split(',', 2)
              city = address[0].trim()
              country = address[1].trim()

              setHiddenFields position.coords.latitude, position.coords.longitude, city, country
              countryInput.val(country)
              cityInput.val(city)
              latInput.val(position.coords.latitude)
              lngInput.val(position.coords.longitude)

              autoCompleteInput.val(address)
              setMarker latlng
            else 
              console.debug "Geocode was not successful for the following reason: " + status

        (error) ->
          console.debug "HTML5 Geolocation not supported!"
      )
    else
      console.debug "Geolocation is not supported by your browser!"
  else
    #location already set
    setMarker new google.maps.LatLng(latInput.val(), lngInput.val())
    autoCompleteInput.val cityInput.val() + ", " + countryInput.val()

  # location via user input
  google.maps.event.addListener autocomplete, 'place_changed', ->
    place = autocomplete.getPlace()

    if !!place.geometry
      autoCompleteInput.attr "data-valid", "true"
      autoCompleteInput.trigger "change"
      setMarker place.geometry.location

      address = place.address_components
      setHiddenFields place.geometry.location.Ya, place.geometry.location.Za, address[0].long_name, address[3].long_name
    else
      autoCompleteInput.attr "data-valid", "false"

