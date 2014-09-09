class Settings
  extend ActiveModel::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations


  attr_accessor :language, :auth_token, :old_password, :new_password, :mail_notifications

  validates :new_password, confirmation: true

  def initialize(user)
    self.language = user.language
    self.auth_token = user.auth_token
    self.mail_notifications = user.try(:mail_notifications) || 'daily'
  end

  def persisted?
    false
  end

  def id
    nil
  end

end
