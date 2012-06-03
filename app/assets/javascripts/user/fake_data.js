function fill_in_user(){
  $('#user_firstname').val("Chuck");
  $('#user_lastname').val("Norris");
  $('#male_link').trigger("click");
  $('#user_age').val("100");
  $('#user_email').val("chuck@norris.com");
  $('#recipe_preparation').val("This is a test preparation for test potatoe");
  $('input[name="user[heard_from]"]').prop('checked', true);
  $('#country').val("Austria");
  $('#city').val("Salzburg");
  $('#longitude').val("47.812002");
  $('#latitude').val("13.055019");
}