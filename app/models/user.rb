class User < ActiveRecord::Base
  include Authenticable
  include Contacts
  include Contributor
  include Geometry
  include Taggable
  include Followable
  include Follower
  include Searchable
  include PublicActivity::Common
  include Flaggable

  mount_uploader :avatar, AvatarUploader
  process_in_background :avatar

  geojson_field :location
  searchable_tags :interests
  search_fields multi: [:name, :about_me]

  has_many :imports
  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  attr_reader :license_aggrement

  validates :email, :name,      presence:     true
  validates :email,             uniqueness:   true
  validates :email,             format:       {with: /.+@.+\..+/i}
  validates :password,          confirmation: true

  validates :password,          presence:     true,         on: :create
  validates :password,          length:       {minimum: 6}, on: :create
  validates :license_aggrement, acceptance:   true,         on: :create

  before_create :set_auth_token

  def send_activation_email
    UserMailer.delay.activation_email(id, I18n.locale)
  end

  def send_reset_password_email!
    # override sorcery reset password to use sidekiq
    UserMailer.delay.reset_password_email(id, I18n.locale)
  end

  def geojson_properties
    {name: name, id: id}
  end

  def activities_performed
    PublicActivity::Activity.where(owner: self).includes(:trackable).order('created_at desc')
  end

  def notifications
    Notification.includes(activity: [:trackable, :owner]).where(user: self).order('created_at desc')
  end

  def unread_notifications_count
    Notification.where(user: self, status: "unread").count
  end

  def settings
    @settings ||= Settings.new(self)
  end

  def admin?
    Admin.where(user_id: id).exists?
  end

  def oauth_access_tokens
    Doorkeeper::AccessToken.where(resource_owner_id: id)
  end

  def oauth_authorized_applications
    Doorkeeper::Application.joins(:access_tokens).where(access_tokens: {resource_owner_id: id})
  end

  private

    def set_auth_token
      return if auth_token.present?
      self.auth_token = generate_auth_token
    end

    def generate_auth_token
      SecureRandom.uuid.gsub(/\-/, '')
    end
end
