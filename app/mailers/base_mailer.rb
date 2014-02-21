class BaseMailer < ActionMailer::Base
  layout 'mail'
  default from: 'MootiroMaps <no-reply@it3s.mailgun.org>'

  def self.delay
    # specify sidekiq queue for our delayed mails
    super(:queue => 'mailer')
  end

  protected

  def email_with_name(user)
    "#{user.name} <#{user.email}>"
  end
end
