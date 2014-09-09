class Settings
  extend ActiveModel::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :user, :language, :auth_token, :mail_notifications

  def initialize(user)
    self.user = user
    self.language = user.language
    self.auth_token = user.auth_token
    self.mail_notifications = user.mail_notifications
  end

  def assign_attributes(attrs)
    attrs.each { |name, value| send "#{name}=", value }
  end

  def save
    user.assign_attributes language: language, mail_notifications: mail_notifications
    user.save
  end

  def persisted?
    false
  end

  def id
    nil
  end

end
