module ApplicationHelper

def handle_error_messages(object)
  showErrorLatLng = false
  html = ""
  html<<"<div id='error_explanation'><h2>#{pluralize(object.errors.count, "error")} prohibited this #{object.class.to_s} from being saved:</h2>"
  html<<"<p>There were problems with the following fields:</p>"
  html<<"<ul>"
  object.errors.full_messages.each do |msg|
    puts msg
    if msg.include?("Longitude") || msg.include?("Latitude")
      if showErrorLatLng == false
        msg = "The country or city can't be found" 
        html<<"<li>#{msg}.</li>"
        showErrorLatLng = true
      else
        next
      end
    else
      html<<"<li>#{msg}.</li>"
    end
  end
  html<<"</ul></div>"
end
end
