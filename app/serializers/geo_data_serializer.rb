class GeoDataSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :location, :additional_info, :contacts,
             :tags, :relations, :created_at, :updated_at

  def relations
    object.relations_values(splitted_type: true)
  end
end
