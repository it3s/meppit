class MapSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :additional_info, :contacts, :tags,
             :created_at, :updated_at

  has_many :geo_data
end
