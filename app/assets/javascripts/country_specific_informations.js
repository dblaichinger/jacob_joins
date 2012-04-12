var publish_csi = function(id, user_location) {
  var error = false;

  $.ajax({
    url: "country_specific_informations/draft",
    type: "POST",
    async: false,
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

$(document).ready(function(){
  $("form", "#country_specific_information_tab").dirty_form({dynamic:true}).dirty(function(event, event_data){
    var fields = $(".changed", "#country_specific_information_tab");

    if(fields.size() > 0)
      $("#aboutyourcountry").parent().addClass("form_valid")
    else
      $("#aboutyourcountry").parent().removeClass("form_valid")
  });
});