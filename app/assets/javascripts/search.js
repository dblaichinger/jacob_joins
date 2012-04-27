$(document).ready(function(){

  $('#ingredients_search_form').bind("ajax:success", function(evt, data, status, xhr){
    console.debug(data);
    
    if (data.ingredients.length == 0)
      $('#search_selection').append("<p>No results!</p>");
    else{
      $.each(data.ingredients, function(key, ingredient){
        
        var ingredient_exists = false
        $.each($('#search_hidden input:hidden'), function(key, input){
          console.debug($(input).attr("name"));
          console.debug(ingredient);

          if($(input).attr("name") == "ingredients["+ingredient+"]"){
            ingredient_exists = true;
          }
        });

        if(!ingredient_exists){ 
          $('#search_hidden').append("<input type='hidden' name='ingredients["+ingredient+"]' value='"+ingredient+"' >");
          $('#search_selection').append("<p>"+ingredient+"</p>");
        }

        //console.debug();
        //$('#search_selection').append("<p>"+ingredient._id+"</p>");

        //console.debug (ingredient.toString());
        //console.debug($('#search_form input[name="'+ingredient+'"]'));
      });

      var output ="";
      $.each(data.recipes, function(key, recipe){
        if (recipe != null){
          output += ("<p>"+recipe._id+"</p>");
          output += ("<p>"+recipe.name+"</p>");
        }
      });
      $('#search_result').html(output)
    }
      
      
    })
    .bind("ajax:error", function(evt, xhr, status, error){
      console.log("Cannot find any ingredient due to the following reason: "+error)
    });

});