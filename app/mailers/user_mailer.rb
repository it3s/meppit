class UserMailer < BaseMailer

  def activation_email(user_id)
    @user = User.find user_id
    @activation_url  = activate_user_url @user.activation_token
    mail :to      => email_with_name(@user),
         :subject => t('users.mail.welcome.subject')
  end

end
