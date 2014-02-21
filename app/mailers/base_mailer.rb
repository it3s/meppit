class BaseMailer < ActionMailer::Base
  layout 'mail'
  default from: 'MootiroMaps <no-reply@it3s.mailgun.org>'

  def self.delay
    super(:queue => 'mailer')
  end

  protected

  def email_with_name(user)
    "#{user.name} <#{user.email}>"
  end
end
