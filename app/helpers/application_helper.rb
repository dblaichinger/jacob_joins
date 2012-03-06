module ApplicationHelper

def handle_error_messages(object)
  html = ""
  html<<"<div id='error_explanation'><h2>#{pluralize(object.errors.count, "error")} prohibited this #{object.class.to_s} from being saved:</h2>"
  html<<"<p>There were problems with the following fields:</p>"
  html<<"<ul>"
  object.errors.full_messages.each do |msg|
    if msg.include?("Longitude") || msg.include?("Latitude")
      msg = "The country or city can't be found."
    end
    html<<"<li>#{msg}</li>"
  end
  html<<"</ul></div>"
end

end
