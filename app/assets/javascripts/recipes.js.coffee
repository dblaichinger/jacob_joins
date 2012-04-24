window.publish_recipe = (id, user_location) ->
  return_value = false

  $.ajax
    url: "recipes/draft"
    type: "POST"
    async: false
    data:
      _method: "PUT"
      user_id: id
      location: user_location

    success: (data, textStatus, jqXHR) ->
      return_value = data

    statusCode:
      304: ->
        return_value = false

      400: ->
        return_value = false

      500: ->
        return_value = false

  return_value