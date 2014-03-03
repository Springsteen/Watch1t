class UserMailer < ActionMailer::Base
   default from: 'hrisi.zarkov@gmail.com'
  
  def email(user,subject_text,body_text)
    @user = user
    mail(to: @user.email, subject: subject_text,body: body_text)
  end
end
