class GeoDataSerializer < ActiveModel::Serializer
  include BaseSerializer

  attributes :id, :name, :description, :location, :additional_info, :contacts,
             :tags, :relations, :created_at, :updated_at

  def relations
    object.relations_values(splitted_type: true)
  end

  def location
    # some times we don't get location from database
    object.try(:location)
  end
end
