class Settings
  extend ActiveModel::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :language, :auth_token

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
