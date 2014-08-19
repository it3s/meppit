class GeoDataSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :location, :additional_info, :contacts,
             :tags, :relations

  def relations
    object.relations_values
  end
end
