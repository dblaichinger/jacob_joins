class FeedbackMailer < ActionMailer::Base
  default to: "hello@jacobjoins.com"

  def user_feedback(sender, subject, message)
    @sender = sender
    @message = message
    mail :from => sender[:email], :subject => subject
  end
end