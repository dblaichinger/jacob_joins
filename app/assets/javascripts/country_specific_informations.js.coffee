window.publish_csi = (id, user_location) ->
  return_value = false
  $.ajax
    url: "country_specific_informations/draft"
    type: "POST"
    async: false
    data:
      _method: "PUT"
      user_id: id
      location:
        latitude: user_location.latitude
        longitude: user_location.longitude
        city: user_location.city
        country: user_location.country

    success: (data, textStatus, jqXHR) ->
      return_value = data

    statusCode:
      400: ->
        return_value = false

      500: ->
        return_value = false

  return_value