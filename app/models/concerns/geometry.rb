module Geometry
  extend ActiveSupport::Concern

  module ClassMethods
    def geofactory
      RGeo::Geographic.spherical_factory :srid => 4326
    end

    def geojson_field(*fields)
      fields.each do |field|
        set_rgeo_factory_for_column field, geofactory.projection_factory
        define_method "#{field}_geojson" do
          ::GeoJSON::encode(send(field), id, geojson_properties).to_json
        end
      end
    end
  end

end
