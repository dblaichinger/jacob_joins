

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
        //console.debug(results);
      //}
      var objectnumber = results.length-4;
      var address = results[objectnumber].formatted_address;

      address = address.split(',', 2);
      var city = address[0].trim();
      var country = address[1].trim();

      $('#recipe_country').val(country);
      $('#recipe_city').val(city);
      $('#recipe_latitude').val(lat);
      $('#recipe_longitude').val(lng);        
    } 
    else {
      console.log("Geocode was not successful for the following reason: " + status);
    }
  });
}


function getLatLngFromAddress(city, country){
  var address = city +", "+ country;
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
        //console.debug(results);
        $('#recipe_latitude').val(results[0].geometry.location.Pa);
        $('#recipe_longitude').val(results[0].geometry.location.Qa);
    } else {
      console.log("Geocode was not successful for the following reason: " + status);
    }
  });
}

function addErrorOnField(field){
  field.wrap('<div class="field_with_errors" />');
}
