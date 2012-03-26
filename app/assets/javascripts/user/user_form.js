function gender_icon(classname){
  $('.female').css('border', 'none');
  $('.male').css('border', 'none');
  $('#user_gender').val(classname); 
  $('.'+classname).css('border', '1px solid red'); 
  return false;
}

function heard_from(option){
  if(option == "other")
    $('#heard_from_other').fadeIn('500');
  else 
    $('#heard_from_other').fadeOut('500');
}