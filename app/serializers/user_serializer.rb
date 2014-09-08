class UserSerializer < ActiveModel::Serializer
  include BaseSerializer

  attributes :id, :name, :about_me, :language, :location, :contacts,
             :interests, :avatar, :created_at, :active

  def active
    object.activation_state == 'active'
  end

  def avatar
    object.avatar_url
  end

end
