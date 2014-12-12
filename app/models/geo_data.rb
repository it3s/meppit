class GeoData < ActiveRecord::Base
  include Contacts
  include Geometry
  include Taggable
  include Followable
  include Contributable
  include Mappable
  include Searchable
  include Relationships
  include Exportable
  include PublicActivity::Common
  include Commentable
  include Flaggable
  include Featurable

  geojson_field :location
  searchable_tags :tags
  search_fields scoped: :name, multi: [:name, :description]
  has_maps
  has_paper_trail ignore: [:id, :created_at, :updated_at]
  has_many :pictures, as: :content

  validates :name, presence: true

  scope :nearest, -> lon, lat do
    point = geofactory.point(lon, lat).as_text
    order{ST_Distance(ST_MakeValid(location), ST_Geomfromtext(point, 4326))}
  end

  scope :tile, -> x, y, zoom do
    polygon = tile_as_polygon(x, y, zoom)
    # Gets GeoJSON directly from PostGIS because RGeo is very slow.
    features = select("geo_data.id, geo_data.name, geo_data.tags, geo_data.created_at, geo_data.updated_at, ST_AsGeoJSON(geo_data.location) as geometry").where{ST_Intersects(location, ST_Geomfromtext(polygon, 4326))}.map {
      |item|
      {
        type: "Feature",
        id: item.id,
        properties: {
          name: item.name,
          created_at: item.created_at,
          updated_at: item.updated_at,
          tags: item.tags
        },
        geometry: JSON.parse(item.geometry)
      }
    }
    {type: "FeatureCollection", features: features}
  end

  def geojson_properties
    active_model_serializer.new(self).serializable_hash.except(:location)
  end
end
