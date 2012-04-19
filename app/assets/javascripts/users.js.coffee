###
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
  unless typeof google is 'object' and typeof google.maps is 'object' 
    console.log "Google Maps API not available."
    return false

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

  requestlocation = () ->
    console.log("changehandler!")
    address = autoCompleteInput.val()
    console.log(address)
    geocoder = new google.maps.Geocoder()
    geocoder.geocode
      address: address, (results, status) ->
        if status is google.maps.GeocoderStatus.OK
          autoCompleteInput.attr "data-valid", "true"
          if results[0].address_components.length > 1
            city = results[0].address_components[0].long_name
            country = results[0].address_components[results[0].address_components.length-1].long_name
            setHiddenFields results[0].geometry.location.lat(), results[0].geometry.location.lng(), city, country 
            autoCompleteInput.val(city+", "+country)
            console.log(city+", "+country)
          else
            city = null
            country = results[0].address_components[0].long_name
            setHiddenFields results[0].geometry.location.lat(), results[0].geometry.location.lng(), city, country
            autoCompleteInput.val(country)
            console.log(country)
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
  google.maps.event.addListener autocomplete, 'place_changed', () ->
    
    #autoCompleteInput.off "change", requestlocation
    clearTimeout autoCompleteInput.data('timeout')
    console.log "autocomplete handler"
     
    place = autocomplete.getPlace()

    if !!place.geometry
      autoCompleteInput.attr "data-valid", "true"
      setMarker place.geometry.location
      address = place.address_components
      console.log(address)
      if address.length > 1
        setHiddenFields place.geometry.location.lat(), place.geometry.location.lng(), address[0].long_name, address[address.length-1].long_name
      else
        setHiddenFields place.geometry.location.lat(), place.geometry.location.lng(), null, address[0].long_name
    else
      autoCompleteInput.attr "data-valid", "false"

    #autoCompleteInput.on "change", requestlocation

###


