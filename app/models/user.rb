class User < ActiveRecord::Base
  include Contacts
  include Geometry
  include Taggable

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  mount_uploader :avatar, AvatarUploader
  process_in_background :avatar

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  geojson_field :location
  searchable_tags :interests

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

  def send_reset_password_email!
    # override sorcery reset password to user sidekiq
    UserMailer.delay.reset_password_email(id, I18n.locale)
  end

  def geojson_properties
    {:name => name, :id => id}
  end

  def followers_count
    #TODO refactor to concern
    0
  end

  def maps_count
    #TODO refactor to concern
    0
  end
end
