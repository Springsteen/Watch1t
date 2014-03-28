class UserMailer < ActionMailer::Base
   default from: 'hrisi.zarkov@gmail.com'
  
  def email(email,subject_text,body_text)
    mail(to: email, subject: subject_text,body: body_text)
  end
end
