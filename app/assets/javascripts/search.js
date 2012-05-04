$(document).ready(function(){

  $('#ingredients_search_form').bind("ajax:success", function(evt, data, status, xhr){
    console.debug(data);
    printResults(data);   
  })
  .bind("ajax:error", function(evt, xhr, status, error){
    console.log("Cannot find any ingredient due to the following reason: "+error)
  });
});

function runSearchTest(){
  var times = $('#search_times').val();
  var search_data = {"ingredients": []};
  var ingredient_arr = [];
  for(var i=0; i< times; i++){
    var search_ingredient = "ingredient"+Math.floor(Math.random()*1000);

    search_data.ingredients.search = search_ingredient;
    $.each(ingredient_arr, function(key, val){
      search_data.ingredients["ingredient["+val+"]"] = val;//("{ingredient["+val+"]: "+val+"}");
    });
    ingredient_arr.push(search_ingredient);

    console.debug(search_data);

    $.ajax({
      url: 'search',
      data: search_data,
      type: "POST",
      success: function(data) {
        printResults(data);
      },
      error: function(data){
        console.debug(data);
      }
    }, "json");
  }
}


function printResults(data){
  if (data.ingredients.length == 0)
    $('#search_selection').append("<p>No results!</p>");
  else{
    $.each(data.ingredients, function(key, ingredient){
      
      var ingredient_exists = false
      $.each($('#search_hidden input:hidden'), function(key, input){

        if($(input).attr("name") == "ingredients["+ingredient+"]"){
          ingredient_exists = true;
        }
      });

      if(!ingredient_exists){ 
        $('#search_hidden').append("<input type='hidden' name='ingredients["+ingredient+"]' value='"+ingredient+"' >");
        $('#search_selection').append("<p>"+ingredient+"</p>");
      }
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
}