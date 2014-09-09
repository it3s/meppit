class Settings
  extend ActiveModel::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations


  attr_accessor :user, :language, :auth_token, :old_password, :new_password,
                :mail_notifications

  validate  :change_password
  validates :new_password, confirmation: true

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

  private

    def change_password
      unless [old_password, new_password, new_password_confirmation].all? &:blank?
        errors.add :old_password, 'invalid password' unless User.authenticate(@user.email, old_password)
        errors.add :new_password, 'provide a new password' if new_password.blank?
        errors.add :new_password, 'password is too short' if new_password.size < 6
      end
    end

end
