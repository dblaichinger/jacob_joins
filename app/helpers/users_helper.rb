module UsersHelper
  def formatted_user_name(user)
    "#{user.firstname.capitalize}#{' ' + user.lastname[0].upcase + '.' if user.lastname.present?}"
  end
end
