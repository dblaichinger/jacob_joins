ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args| #|name, start, finish, id, payload|
  event = ActiveSupport::Notifications::Event.new(*args)
  Rails.logger.debug "-----------------------------------------------"
  Rails.logger.debug "Event: "+event.inspect
end

ActiveSupport::Notifications.subscribe "ingredients.search" do |*args|
	event = ActiveSupport::Notifications::Event.new(*args)
	Rails.logger.debug "-----------------------------------------------"
	Rails.logger.debug "INGREDIENTS.SEARCH: "+ event.inspect
end
