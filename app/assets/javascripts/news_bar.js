function countdown(){
  var days;
  var hours;
  var minutes;
  var seconds;

  var now = new Date();
  now.getTime();
  var time = Date.parse(now);
  
  var release = Date.parse("Su, 03 Jun 2012 00:00:00 GMT+1");
  
  var diff = release - time;
  
  if (diff < 0){
    days = hours = minutes = seconds = "00";
  }
  else {
    var diff = diff /1000;
    
    days = Math.floor( diff/(60*60*24) );
    if(days < 10) days = "0"+days;
    
    hours = Math.floor( (diff - days*24*60*60)/(60*60) );
    if(hours < 10) hours = "0"+hours;
    
    minutes = Math.floor( (diff - days*24*60*60 - hours*60*60)/60);
    if(minutes < 10) minutes = "0"+minutes;
    
    seconds = Math.floor( diff - days*24*60*60 - hours*60*60 - minutes*60);
    if(seconds < 10) seconds = "0"+seconds;
  }

  $('#days').html(days);
  $('#hours').html(hours);
  $('#minutes').html(minutes);
  $('#seconds').html(seconds);
  
  setTimeout('countdown()',200);

};


function get_latest_recipe(){
  $.get('/recipes/last', function(data, textstatus, jqxhr) {
    var recipe = data;
    //console.debug(recipe);
    if(data.user_id){
      var id = {"id": data.user_id};
      //Get the user, which created the recipe
      $.post('/users/find_user', id, function(data, textstatus, jqxhr) {
        var user = data;
        //console.debug(user);
        if(user.name && recipe.city)
          $('#last_entry').append("<p>Jacob joins "+user.name+" from "+recipe.city+"</p>");
      }, "json");
    }
  }, "json");
}

