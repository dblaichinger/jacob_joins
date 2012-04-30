function get_latest_recipe(){
  $.get('/recipes/last', function(data, textstatus, jqxhr) {
    $.each(data, function(key, value){
      var recipe = value;
      if(recipe && recipe.user_id){
        var id = {"id": recipe.user_id};
        //Get the user, which created the recipe
        $.post('/users/find_user', id, function(data, textstatus, jqxhr){
          var user = data;

          if(user.name && recipe.city)
            $('#last_entry').append("<p>Jacob joins "+user.name+" from "+recipe.city+"</p>");
        }, "json");
      }
    });
  }, "json");
}

function get_facebook_stream(){
  var token = "379307568767425|h4-QpwOXsOJgj36C6ynugq6hQTs";
  $.get('https://graph.facebook.com/111627842294635/feed?access_token='+token, function(data, textstatus, jqxhr){
    var counter = 0;
    $.each(data.data, function(key, value){
      if(value.message && counter <= 4){
        $.get('https://graph.facebook.com/'+value.from.id+'?fields=picture&type=square', function(data, textstatus, jqxhr){
          if($('#newsbar #fb .post').length <= 0)
            $('#newsbar #fb .content').append("<div class='post'>");
          else
            $('#newsbar #fb .post:last').after("<div class='post'>");

          var current_post = $('#newsbar #fb .post:last');
          current_post.append("<img src='"+data.picture+"' alt='profile_picture' />");
          current_post.append("<h5>"+value.from.name+"</h5>");
          current_post.append("<p class='message'>"+value.message+"</p>");
          current_post.append("<p class='time'>"+ prettyDate(value.created_time) +"</p>");
          current_post.append("</div>");
          $("#mcs_container").mCustomScrollbar("vertical", 0, "easeOutCirc", 1.05, "auto", "yes", "no", 0);  
        }, "json");

        counter++;
      }
    });
  }, "json");
}

/*
 * JavaScript Pretty Date
 * Copyright (c) 2011 John Resig (ejohn.org)
 * Licensed under the MIT and GPL licenses.
 */
// Takes an ISO time and returns a string representing how
// long ago the date represents.
function prettyDate(time){
  var date = new Date((time || "").replace(/-/g,"/").replace(/[TZ]/g," ")),
    diff = (((new Date()).getTime() - date.getTime()) / 1000),
    day_diff = Math.floor(diff / 86400);
      
  if ( isNaN(day_diff) || day_diff < 0 || day_diff >= 31 )
    return;
      
  return day_diff == 0 && (
      diff < 60 && "just now" ||
      diff < 120 && "1 minute ago" ||
      diff < 3600 && Math.floor( diff / 60 ) + " minutes ago" ||
      diff < 7200 && "1 hour ago" ||
      diff < 86400 && Math.floor( diff / 3600 ) + " hours ago") ||
    day_diff == 1 && "Yesterday" ||
    day_diff < 7 && day_diff + " days ago" ||
    day_diff < 31 && Math.ceil( day_diff / 7 ) + " weeks ago";
}

// If jQuery is included in the page, adds a jQuery plugin to handle it as well
if ( typeof jQuery != "undefined" )
  jQuery.fn.prettyDate = function(){
    return this.each(function(){
      var date = prettyDate(this.title);
      if ( date )
        jQuery(this).text( date );
    });
  };


function slide_newsbar(){
  $('#clickandsee').click(function(e){
    return false;
  });

  var event_set = false;
  $(document).ready(function(){
    $("#newsbar").hover(
      function(){
        if(event_set) { event_set = false; $("#clickandsee").stop(true, true).fadeIn(500); }
      },
      function(){
        if(!event_set) { event_set = true; $("#clickandsee").stop(true, true).fadeOut(500); }
      }
    );
  });
  
  $("#newsbar, .show_newsbar").click(function(e){
    var newsBar = $('#newsbar');

    if(newsBar.hasClass('extended')){
      newsBar.stop().animate({
        top: "-215px"
      }, 500).hover(function(){ $("#clickandsee").stop(true, true).fadeIn(500); }, function(){ $("#clickandsee").stop(true, true).fadeOut(500); });
    } else {
      newsBar.stop().animate({
        top: "0"
      }, 500).unbind('mouseenter').unbind('mouseleave');
    }

    $("#countdown", newsBar).fadeToggle(500);
    $("#clickandsee", newsBar).stop(true, true).fadeOut(500);

    $('#newsbar').toggleClass('extended');

    return false;
  });
}