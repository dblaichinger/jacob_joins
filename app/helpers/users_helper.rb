module UsersHelper
  def formatted_user_name(user)
    "<em>#{user.firstname.capitalize} #{user.shorten_lastname}</em>,".html_safe
  end
end
