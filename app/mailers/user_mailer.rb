class UserMailer < BaseMailer

  def welcome(user_id)
    @user = User.find user_id
    mail :to      => email_with_name(@user),
         :subject => t('users.mail.welcome.subject')
  end

end
