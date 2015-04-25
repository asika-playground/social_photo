class UserMailer < ApplicationMailer
  default :from => "foobar@example.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify_comment.subject
  #
  def notify_comment(user, comment)
    @greeting = "Hi"

    mail to: "to@example.org", :subject => "New comment has been replied for"
  end
end
