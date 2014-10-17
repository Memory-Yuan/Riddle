class UserMailer < ActionMailer::Base
    default from: ENV['EMAIL']
  
    def welcome_email(user)
        @user = user
        mail(to: @user.email, subject: "Welcome!")
    end 
end
