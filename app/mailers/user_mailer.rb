class UserMailer < BaseMailer

  def activation_email(user_id, lang=nil)
    set_user_and_locale user_id, lang
    @activation_url  = activate_user_url @user.activation_token
    mail :to      => email_with_name(@user),
         :subject => t('users.mail.welcome.subject')
  end

  def reset_password_email(user_id, lang=nil)
    set_user_and_locale user_id, lang
    @url  = edit_password_users_url(@user.reset_password_token)
    mail :to      => @user.email,
         :subject => t('user.forgot_password.mail_subject')
  end

  private

  def set_user_and_locale(user_id, lang)
    I18n.locale = lang || I18n.default_locale
    @user = User.find user_id
  end
end
