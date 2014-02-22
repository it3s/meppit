class BaseMailer < ActionMailer::Base
  layout 'mail'
  default from: 'Meppit <no-reply@it3s.mailgun.org>'

  def self.delay
    # specify sidekiq queue for our delayed mails
    sidekiq_delay(:queue => 'mailer')
  end

  def self.email_with_name(user)
    "#{user.name} <#{user.email}>"
  end

  def email_with_name(user)
    self.class.email_with_name(user)
  end
end
