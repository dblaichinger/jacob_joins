function gender_icon(classname){
  $("#user_gender").val(classname);
  gendericons = $("#gendericons").children();
  otherGender = gendericons.not("." + classname);
  otherGender.removeAttr("style");
  $("#" + classname + "_link").css("background-position", "0px -63px");
  $(".dirtyform", "#user_tab").dirtyValidation("validate", $("#user_gender"), false);
  $("#user_gender").addClass("changed");
  return false;
}

function heard_from(option){
  if(option == "other"){
    $("#heard_from_other").fadeIn("500", function(){
      $("#user_heard_from").addClass("changed");
      $(".user_form .error").qtip("reposition");
    });
  }
  else{
    $("#heard_from_other").fadeOut("500", function(){
      $("#user_heard_from").addClass("changed");
      $(".user_form .error").qtip("reposition");
    });
  }
}