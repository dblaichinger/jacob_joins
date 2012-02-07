var coords;
 
function getGeoLocation(){
    if (navigator.geolocation) {
        // GeoLocation verfügbar
        navigator.geolocation.getCurrentPosition(saveCoords);
    } else {
        // GeoLocation not available
        console.log('Geolocation is not supported by your browser!');
    }
}
 
function saveCoords(position){
    coords = position.coords.latitude + ',' + position.coords.longitude;
    console.debug(coords);
    getAddress(position.coords.latitude, position.coords.longitude);
}

function getAddress(lat, lng){
  var latlng = new google.maps.LatLng(lat, lng);
  geocoder = new google.maps.Geocoder();
  geocoder.geocode({'latLng': latlng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      for(var i in results){
        //console.debug(results);
      }
      var objectnumber = results.length-2;
      var address = results[objectnumber].formatted_address;

      console.debug(address);
        
    } else {
      console.log("Geocoder failed due to: " + status);
    }
  });
}
