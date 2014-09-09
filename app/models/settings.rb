class Settings
  extend ActiveModel::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations


  attr_accessor :language, :auth_token, :old_password, :new_password

  validates :new_password, confirmation: true

  def initialize(user)
    self.language = user.language
    self.auth_token = user.auth_token
  end

  def persisted?
    false
  end

  def id
    nil
  end

end
