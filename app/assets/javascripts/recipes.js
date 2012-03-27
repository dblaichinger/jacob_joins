var publish_recipe = function(id, user_location) {
  var error = false;

  $.ajax({
    url: "recipes/draft",
    type: "POST",
    data: {
      _method: "PUT",
      user_id: id,
      location:{
        latitude: user_location.latitude,
        longitude: user_location.longitude,
        city: user_location.city,
        country: user_location.country
      }
    },
    success: function(data, textStatus, jqXHR) { error = false; },
    statusCode: {
      400: function(){ error = true; },
      500: function(){ error = true; }
    }
  });

  return !error
};