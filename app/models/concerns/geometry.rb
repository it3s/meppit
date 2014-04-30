module Geometry
  extend ActiveSupport::Concern

  included do |base|
    base.rgeo_factory_generator = RGeo::Geos.factory_generator(:srid => 4326)
  end

  module ClassMethods
    def geojson_field(*fields)
      fields.each do |field|
        define_method "#{field}_geojson" do
          ::GeoJSON::encode(send field).to_json
        end
      end
    end
  end

end
