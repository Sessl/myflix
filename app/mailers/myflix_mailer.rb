class MyflixMailer < ActionMailer::Base
  def notify_on_signup(user)
    @user = user
    mail from: info@myflixapp.com, to: user.email, subject: "Welcome to Myflix"
  end
end