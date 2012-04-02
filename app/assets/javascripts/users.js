var publish_user = function() {
  var return_value = false;

  $.ajax({
    url: "users/draft",
    type: "POST",
    data: { _method: "PUT" },
    async: false,
    success: function(data, textStatus, jqXHR) { return_value = data; },
    statusCode: {
      304: function(){ return_value = true; },
      400: function(){ return_value = false; },
      410: function(){ return_value = true; },
      500: function(){ return_value = false; }
    }
  });

  return return_value
};