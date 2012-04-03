var publish_recipe = function(id, user_location) {
  var error = false;

  $.ajax({
    url: "recipes/draft",
    type: "POST",
    async: false,
    data: {
      _method: "PUT",
      user_id: id,
      location: user_location
    },
    success: function(data, textStatus, jqXHR) { error = false; },
    statusCode: {
      304: function(){ error = false; },
      400: function(){ error = true; },
      500: function(){ error = true; }
    }
  });

  return !error
};