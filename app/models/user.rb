class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_reader :license_aggrement

  validates :email, :name,      :presence     => true
  validates :email,             :uniqueness   => true
  validates :email,             :format       => {:with => /.+@.+\..+/i}
  validates :password,          :confirmation => true
  validates :password,          :presence     => true, :on => :create
  validates :password,          :length       => {:minimum => 6}, :on => :create
  validates :license_aggrement, :acceptance   => true, :on => :create

  def send_activation_email
    UserMailer.delay.activation_email(id, I18n.locale)
  end

end
