class UserMailer < BaseMailer

  def activation_email(user_id, locale=nil)
    mail_with_token user_id, locale do |user| activate_user_url(user.activation_token) end
  end

  def reset_password_email(user_id, locale=nil)
    mail_with_token user_id, locale do |user| edit_password_users_url(user.reset_password_token) end
  end

  private

  def mail_with_token(user_id, locale, &block)
    set_user_and_locale user_id, locale
    @url = block.call(@user)
    mail :to => email_with_name(@user)
  end

  def set_user_and_locale(user_id, locale)
    I18n.locale = locale || I18n.default_locale
    @user = User.find user_id
  end
end
