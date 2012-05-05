function gender_icon(classname){
  $(".female").attr("src", "/assets/female_inactive.png");
  $(".male").attr("src", "/assets/male_inactive.png");
  $("#user_gender").val(classname);
  $("." + classname).attr("src", "/assets/" + classname + "_active.png");
  $("#user_gender").addClass("changed");
  $(".dirtyform", "#user_tab").dirtyValidation("validate", $("#user_gender"), false);
  return false;
}

function heard_from(option){
  if(option == "other")
    $("#heard_from_other").fadeIn("500");
  else 
    $("#heard_from_other").fadeOut("500");
}

$(document).ready(function(){
  $(".female, .male").live("mouseenter", function(){
    var classname = $(this).hasClass("male") ? "male" : "female"
    $(this).attr("src", "/assets/" + classname + "_hover.png");
  });

  $(".female, .male").live("mouseleave", function(){
    var classname = $(this).hasClass("male") ? "male" : "female"
    if($("#user_gender").val() != classname)
      $(this).attr("src", "/assets/" + classname + "_inactive.png");
    else if($("#user_gender").val() == classname)
      $(this).attr("src", "/assets/" + classname + "_active.png");
  });
});