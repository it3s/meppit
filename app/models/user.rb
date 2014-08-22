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

  mount_uploader :avatar, AvatarUploader
  process_in_background :avatar

  geojson_field :location
  searchable_tags :interests
  search_fields multi: [:name, :about_me]

  attr_reader :license_aggrement

  validates :email, :name,      presence:     true
  validates :email,             uniqueness:   true
  validates :email,             format:       {with: /.+@.+\..+/i}
  validates :password,          confirmation: true

  validates :password,          presence:     true,         on: :create
  validates :password,          length:       {minimum: 6}, on: :create
  validates :license_aggrement, acceptance:   true,         on: :create

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
end
