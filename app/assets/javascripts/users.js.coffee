window.publish_user = ->
  return_value = false

  $.ajax
    url: "/users/draft"
    type: "POST"
    data:
      _method: "PUT"
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
  unless typeof google is 'object' and typeof google.maps is 'object' 
    console.log "Google Maps API not available."
    return false

  map = new google.maps.Map $('#user_tab .map')[0],
    center: new google.maps.LatLng(47.806357, 13.039623) # lat and lng of salzburg
    zoom: 6
    mapTypeId: google.maps.MapTypeId.ROADMAP # ROADMAP is normal map
    mapTypeControl: false
    overviewMapControl: false
    panControl: false
    scaleControl: false
    streetViewControl: false
    zoomControl: false

  autoCompleteInput = $('#user_tab .address-search')
  autoCompleteInput.keydown (e) ->
    if e.which is 13
      e.preventDefault()

  if $('#longitude').val() isnt "" and $('#latitude').val() isnt "" and $('#country_hidden').val() isnt "" and $('#city_hidden').val() isnt ""
    autoCompleteInput.attr "data-valid", "true"
  else
    autoCompleteInput.attr "data-valid", "false"
  autoCompleteInput.attr "data-error-message", "Location not found."

  requestlocation = () ->
    address = autoCompleteInput.val()
    geocoder = new google.maps.Geocoder()
    geocoder.geocode
      address: address, (results, status) ->
        if status is google.maps.GeocoderStatus.OK
          autoCompleteInput.attr "data-valid", "true"

          if results[0].address_components.length > 1
            city = results[0].address_components[0].long_name
            
            if /[0-9]/.test(results[0].address_components[results[0].address_components.length-1].long_name)
              country = results[0].address_components[results[0].address_components.length-2].long_name
            else
              country = results[0].address_components[results[0].address_components.length-1].long_name
            
            setHiddenFields results[0].geometry.location.lat(), results[0].geometry.location.lng(), city, country 
            autoCompleteInput.val(city+", "+country)
          else
            city = null
            country = results[0].address_components[0].long_name
            setHiddenFields results[0].geometry.location.lat(), results[0].geometry.location.lng(), city, country
            autoCompleteInput.val(country)
          setMarker new google.maps.LatLng(latInput.val(), lngInput.val())
        else
          console.log "Geocode was not successful for the following reason: " + status
          autoCompleteInput.attr "data-valid", "false"
          $('#user_tab form').dirtyValidation("validate", autoCompleteInput, false)
          autoCompleteInput.qtip("show")

  autoCompleteInput.on "change", ()->
    autoCompleteInput.attr "data-valid", "true"
    clearTimeout autoCompleteInput.data('timeout')
    timeout = setTimeout requestlocation, 100
    autoCompleteInput.data timeout: timeout

  autocomplete = new google.maps.places.Autocomplete autoCompleteInput[0], { types: ['(regions)'] }
  autocomplete.bindTo('bounds', map)

  marker = new google.maps.Marker
    map: map

  latInput = $('#latitude')
  lngInput = $('#longitude')
  cityInput = $('#city_hidden')
  countryInput = $('#country_hidden')

  setMarker = (latlng, imageUrl = "/assets/google_marker.png") ->
    map.setCenter latlng
    map.setZoom 9

    image = new google.maps.MarkerImage imageUrl, new google.maps.Size(100, 100), new google.maps.Point(0, 0), new google.maps.Point(25, 55), new google.maps.Size(55, 55)
    marker.setIcon image
    marker.setPosition latlng

  setHiddenFields = (lat, lng, city, country) ->
    latInput.val lat
    lngInput.val lng
    cityInput.val city
    countryInput.val country

  if not latInput.val() or not lngInput.val() or not cityInput.val() or not countryInput.val()
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
              console.log "Geocode was not successful for the following reason: " + status

        (error) ->
          console.log "HTML5 Geolocation not supported!"
      )
    else
      console.log "Geolocation is not supported by your browser!"
  else
    #location already set
    setMarker new google.maps.LatLng(latInput.val(), lngInput.val())
    autoCompleteInput.val cityInput.val() + ", " + countryInput.val()

  # location via user input
  google.maps.event.addListener autocomplete, 'place_changed', () ->

    clearTimeout autoCompleteInput.data('timeout')
   
    place = autocomplete.getPlace()

    if !!place.geometry
      autoCompleteInput.attr "data-valid", "true"
      $('#user_tab form').dirtyValidation("validate", autoCompleteInput, false)
      setMarker place.geometry.location
      address = place.address_components

      if /[0-9]/.test(address[address.length-1].long_name)
        country = address[address.length-2].long_name
      else
        country = address[address.length-1].long_name

      if address.length > 1
        setHiddenFields place.geometry.location.lat(), place.geometry.location.lng(), address[0].long_name, country
      else
        setHiddenFields place.geometry.location.lat(), place.geometry.location.lng(), null, address[0].long_name
    else
      autoCompleteInput.attr "data-valid", "false"







