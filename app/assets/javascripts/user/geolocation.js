

function getGeoLocation(){
  if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(saveCoords);
  } else {
      // GeoLocation not available
      console.log('Geolocation is not supported by your browser!');
  }
}
 
function saveCoords(position){
  var coords = position.coords.latitude + ',' + position.coords.longitude;
  getAddress(position.coords.latitude, position.coords.longitude);
}

function getAddress(lat, lng){
  var latlng = new google.maps.LatLng(lat, lng);
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode({'latLng': latlng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      //Print all results from Google
      //for(var i in results){
      //  console.debug(results);
      //}
      var objectnumber = results.length-4;
      var address = results[objectnumber].formatted_address;

      address = address.split(',', 2);
      var city = address[0].trim();
      var country = address[1].trim();

      $('#country').val(country);
      $('#city').val(city);
      $('#latitude').val(lat);
      $('#longitude').val(lng);        
    } 
    else {
      console.log("Geocode was not successful for the following reason: " + status);
    }
  });
}


function getLatLngFromAddress(){
  var address = $('#recipe_city').val() +", "+ $('#recipe_country').val();
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
        //console.debug(results);
        $('#latitude').val(results[0].geometry.location.lat());
        $('#longitude').val(results[0].geometry.location.lng());
    } else {
      console.log("Geocode was not successful for the following reason: " + status);
    }
  });
  $('#save_user_button').submit();
}

function addErrorOnField(field){
  field.wrap('<div class="field_with_errors" />');
}

