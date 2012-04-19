$(document).ready(function(){

  $('#ingredients_search_form').bind("ajax:success", function(evt, data, status, xhr){
      var test = data;
      console.debug(data[0]);
      $('#search_selection').append("<p>"+data[0].name+"</p>");
      $('#search_selection').append("<p>"+data[0]._id+"</p>");
      $('#search_result').append("<p>"+data[0].recipe_ids[0]+"</p>");
    })
    .bind("ajax:error", function(evt, xhr, status, error){
      console.log("Cannot find any ingredient due to the following reason: "+error)
    });

});