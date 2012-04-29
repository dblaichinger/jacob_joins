class UserMailer < ActionMailer::Base
  default from: "hello@jacobjoins.com"

  def thank_you_wizard(user, recipe, csi_set)
    @user = user
    @recipe = recipe
    @csi_set = csi_set
    mail :to => @user.email, :subject => "Thank you for your participation"
  end
end
