class UserMailer < ActionMailer::Base
  default :from => "nvkprabhu@gmail.com"
  default_url_options[:host] = "173.255.251.28"

  # def activation(user)
  #    @user = user
  #    mail :to => user.email, :body => "http://localhost:3000/activate/#{user.perishable_token}",  :sent_on => Time.now,  :subject => "Activation Instructions",  :from => "noreply@binarylogic.com"
  # end
 
  def activation(user)
    @user = user
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://173.255.251.28/activate/#{user.perishable_token}"
    #    mail :to => user.email, :body => "http://localhost:3000/activate/#{user.perishable_token}",  :sent_on => Time.now,  :subject => "Activation Instructions",  :from => "noreply@binarylogic.com"
  end
 
  def welcome(user)
    @user = user
    setup_email(user)
    @subject = "Welcome to the site!"
    @body  =  "http://173.255.251.28"
  end

  def password_reset_instructions(user)
    subject      "Password Reset Instructions"
    from         "noreply@expressions.com.sg"
    recipients   user.email
    content_type "text/html"
    sent_on      Time.now
    #    password  user.crypted_password
    body         :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def leave_application(application)
    subject "Leave Application"
    from "noreply@expressions.com.sg"
    recipients "yujin7@gmail.com"
    content_type "text/html"
    sent_on      Time.now
    body :application => application
  end
 
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    #   @password = "#{user.crypted_password}"
    @from        = "noreply@expressions.com.sg"
    @subject     = "[agentrefund] - "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
