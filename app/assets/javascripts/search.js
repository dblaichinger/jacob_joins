$(document).ready(function(){

  $('#ingredients_search_form').bind("ajax:success", function(evt, data, status, xhr){
    console.debug(data);
    
    if (data.ingredients.length == 0)
      $('#search_selection').append("<p>No results!</p>");
    else{
      var counter = 1;
      $.each(data.ingredients, function(key, ingredient){
        $('#search_field').after("<input type='hidden' name='ingredients["+ingredient.name+"]' value='"+ingredient.name+"' >");
        $('#search_selection').append("<p>"+ingredient.name+"</p>");
        $('#search_selection').append("<p>"+ingredient._id+"</p>");
        counter++;
      });

      $.each(data.recipes, function(key, recipe){
        $('#search_result').append("<p>"+recipe._id+"</p>");
        $('#search_result').append("<p>"+recipe.name+"</p>");
      });
    }
      
      
    })
    .bind("ajax:error", function(evt, xhr, status, error){
      console.log("Cannot find any ingredient due to the following reason: "+error)
    });

});