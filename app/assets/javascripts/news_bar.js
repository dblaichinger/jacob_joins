function get_latest_recipe(){
  $.get('/recipes/last', function(data, textstatus, jqxhr) {
    $.each(data, function(key, value){
      var recipe = value;
      if(recipe.user_id != null){
        var id = {"id": recipe.user_id};
        //Get the user, which created the recipe
        $.post('/users/find_user', id, function(data, textstatus, jqxhr){
          var user_name = data.name;
        }, "json");
      }
      else {
        var user_name = "an anonymous user"
      }
      if(user_name && recipe.city)
        $('#last_entry').append("<p>Jacob joins <span>"+user_name+"</span> from <span>"+recipe.city+"</span> vor 2 Stunden </p>");
      else
        $('#last_entry').append("<p>Jacob joins <span>an anonymous user</span> from <span>an unknown city</span> </p>");
    });
  }, "json");
}

function get_facebook_stream(){
  var token = "379307568767425|h4-QpwOXsOJgj36C6ynugq6hQTs";
  $.get('https://graph.facebook.com/111627842294635/feed?access_token='+token, function(data, textstatus, jqxhr){
    var counter = 0;
    $.each(data.data, function(key, value){
      if(value.message && counter <= 4){
        if($('#newsbar #fb .post').length <= 0)
          $('#newsbar #fb .content').append("<div class='post'></div>");
        else
          $('#newsbar #fb .post:last').after("<div class='post'></div>");

        var current_post = $('#newsbar #fb .post:last');
        get_facebook_picture(value, current_post);
        counter++;
      }
    });
  }, "json");
}

function get_facebook_picture(post, current_post){  
  $.get('https://graph.facebook.com/'+post.from.id+'?fields=picture&type=square', function(data, textstatus, jqxhr){
    show_facebook_posts(post, current_post, data);
  }, "json");
}

function show_facebook_posts(post, current_post, pic){
  current_post.append("<img src='"+pic.picture+"' alt='profile_picture' />");
  current_post.append("<h5>"+post.from.name+"</h5>");
  current_post.append("<p class='message'>"+post.message+"</p>");
  current_post.append("<p class='time'>"+ prettyDate(post.created_time) +"</p>");
  $("#mcs_container").mCustomScrollbar("vertical", 0, "easeOutCirc", 1.05, "auto", "yes", "yes", 10);
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
    if($(e.target).is($("#newsbar")) || $(e.target).is($(".show_newsbar"))){
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
    }
    else{
      return false;
    }
  });
}