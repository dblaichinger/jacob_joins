window.newsbar ||= {}

window.newsbar.get_latest_recipe = ->
  $.get "/recipes/last", ((data, textstatus, jqxhr) ->
    $("#last_entry").empty()
    $.each data, (key, recipe) ->
      user_name = undefined
      if recipe.user_id?
        id = id: recipe.user_id
        #Get the user, who created the recipe
        $.ajax
          url: "/users/find_user"
          type: "POST"
          data: id
          async: false
          success: (data, textStatus, jqXHR) ->
            user_name = data.firstname
        , "json"
      else
        user_name = "an anonymous user"
      if user_name and recipe.country
        $("#last_entry").append "<p>Jacob joins <span>" + user_name + "</span>from <span>" + recipe.country + "</span></p>"
        $("#last_entry").append "<p class='time'>" + prettyDate(recipe.created_at) + "</p>"
      else
        $("#last_entry").append "<p>Jacob joins <span>an anonymous user</span>from an <span>unknown country</span></p>"
      $("#jj_stream").mCustomScrollbar "vertical", 0, "easeOutCirc", 1.05, "auto", "yes", "yes", 10
  ), "json"

window.newsbar.get_facebook_stream = ->
  token = "379307568767425|h4-QpwOXsOJgj36C6ynugq6hQTs"
  $.get "https://graph.facebook.com/111627842294635/feed?access_token=" + token, ((data, textstatus, jqxhr) ->
    if data
      $("#fb_error").css "display", "none"
      $("#fb .mcs_container").css "display", "block"
    counter = 0
    $.each data.data, (key, value) ->
      if value.message and counter <= 4
        if $("#newsbar_new #fb .post").length <= 0
          $("#newsbar_new #fb .content").append "<div class='post'></div>"
        else
          $("#newsbar_new #fb .post:last").after "<div class='post'></div>"
        current_post = $("#newsbar_new #fb .post:last")
        get_facebook_picture value, current_post
        counter++
  ), "json"

get_facebook_picture = (post, current_post) ->
  $.get "https://graph.facebook.com/" + post.from.id + "?fields=picture&type=square", ((data, textstatus, jqxhr) ->
    show_facebook_posts post, current_post, data
  ), "json"

show_facebook_posts = (post, current_post, pic) ->
  tmp_message = ""
  links_in_message = post.message.match(/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)?(\?[;&a-z\d%_.~+=-]*)?/g)
  $("#fb_stream .content").load ->
    $("#fb_stream").mCustomScrollbar "vertical", 0, "easeOutCirc", 1.05, "auto", "yes", "yes", 10

  current_post.append "<img src='" + pic.picture + "' alt='profile_picture' />"
  current_post.append "<h5>" + post.from.name + "</h5>"
  i = 0

  while links_in_message and i < links_in_message.length
    link_start_pos = post.message.indexOf(links_in_message[i])
    tmp_message = post.message.substring(0, link_start_pos)
    tmp_message += links_in_message[i].link(links_in_message[i])
    tmp_message += post.message.substring(link_start_pos + links_in_message[i].length)
    post.message = tmp_message
    i++
  current_post.append "<p class='message'>" + post.message + "</p>"
  current_post.append "<p class='time'>" + prettyDate(post.created_time) + "</p>"
  $("#fb_stream").mCustomScrollbar "vertical", 0, "easeOutCirc", 1.05, "auto", "yes", "yes", 10

# JavaScript Pretty Date
# Copyright (c) 2011 John Resig (ejohn.org)
# Licensed under the MIT and GPL licenses.
#
# Takes an ISO time and returns a string representing how
# long ago the date represents.

window.prettyDate = (time) ->
  date = (time or "").replace(/-/g, "/").replace(/[TZ]/g, " ").replace(/\+/g, " +")
  index = date.lastIndexOf(":")
  if index > 20
    first = date.substr(0, index)
    second = date.substr(index + 1, date.length)
    date = first + second
  date = new Date(date)
  diff = (((new Date()).getTime() - date.getTime()) / 1000)
  day_diff = Math.floor(diff / 86400)
  return  if isNaN(day_diff) or day_diff < 0 or day_diff >= 31
  day_diff is 0 and (diff < 60 and "just now" or diff < 120 and "1 minute ago" or diff < 3600 and Math.floor(diff / 60) + " minutes ago" or diff < 7200 and "1 hour ago" or diff < 86400 and Math.floor(diff / 3600) + " hours ago") or day_diff is 1 and "Yesterday" or day_diff < 7 and day_diff + " days ago" or day_diff < 31 and Math.ceil(day_diff / 7) + " weeks ago"

replaceAt = (string, index, char) ->
  string.substr(0, index) + char + string.substr(index + char.length)

hideClickAndSee = ->
  if $("html").hasClass("ie7") or $("html").hasClass("ie8")
    $("#clickandsee").hide()
  else
    $("#clickandsee").stop(true, true).fadeOut 500

showClickAndSee = ->
  if $("html").hasClass("ie7") or $("html").hasClass("ie8")
    $("#clickandsee").show()
  else
    $("#clickandsee").stop(true, true).fadeIn 500

window.newsbar.init = ->
  $("#clickandsee").click (e) ->
    false


  setTimeout "$('#clickandsee').mouseleave()", 2500

  $("#newsbar_new").hover (->
    showClickAndSee()
  ), ->
    hideClickAndSee()

  $("#newsbar_new, .show_newsbar").click (e) ->
    if $(e.target).is($("#newsbar_new, .show_newsbar, #newsbar_content, #logo img, #navi_neu ul, #logo_"))
      newsBar = $("#newsbar_new")
      if newsBar.hasClass("extended")
        newsBar.stop().animate(
          top: "-215px"
        , 500).hover (->
          showClickAndSee()
        ), ->
          hideClickAndSee()
      else
        newsBar.stop().animate(
          top: "0"
        , 500).unbind("mouseenter").unbind "mouseleave"
      $("#countdown", newsBar).fadeToggle 500
      hideClickAndSee()
      $("#newsbar_new").toggleClass "extended"
      false
    else
      true

unless typeof jQuery is "undefined"
  jQuery.fn.prettyDate = ->
    @each ->
      date = prettyDate(@title)
      jQuery(this).text date if date

unless $("html").hasClass("ie7")
  window.fbAsyncInit = ->
    FB.init
      channelUrl: "http://www.jacobjoins.com/pages/fb_channel"
      status: true
      cookie: true
      xfbml: true

  ((d, s, id) ->
    js = undefined
    fjs = d.getElementsByTagName(s)[0]
    return  if d.getElementById(id)
    js = d.createElement(s)
    js.id = id
    js.src = "//connect.facebook.net/en_US/all.js"
    fjs.parentNode.insertBefore js, fjs
  ) document, "script", "facebook-jssdk"