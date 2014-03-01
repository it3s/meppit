class UserMailer < BaseMailer

  def activation_email(user_id, lang=nil)
    I18n.locale = lang || I18n.default_locale
    @user = User.find user_id
    @activation_url  = activate_user_url @user.activation_token
    mail :to      => email_with_name(@user),
         :subject => t('users.mail.welcome.subject')
  end

  def reset_password_email(user)

  end
end
