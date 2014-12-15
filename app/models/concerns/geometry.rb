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
          self.send("#{field}_geohash").to_json
        end
        define_method "#{field}_geohash" do
          ::GeoJSON::encode(send(field), id, geojson_properties)
        end
      end
    end

    private

    def tile_as_lat(y, zoom)
      n = 2.0 ** zoom
      lat_rad = Math::atan(Math::sinh(Math::PI * (1 - 2 * y / n)))
      lat = 180.0 * (lat_rad / Math::PI)
    end

    def tile_as_lon(x, zoom)
      n = 2.0 ** zoom
      lon = x / n * 360.0 - 180.0
    end

    def tile_as_polygon(x, y, zoom)
      north = tile_as_lat(y, zoom)
      south = tile_as_lat(y + 1, zoom)
      west  = tile_as_lon(x, zoom)
      east  = tile_as_lon(x + 1, zoom)
      nw = geofactory.point(west, north)
      ne = geofactory.point(east, north)
      sw = geofactory.point(west, south)
      se = geofactory.point(east, south)
      linear_ring = geofactory.linear_ring([nw, ne, se, sw])
      polygon = geofactory.polygon(linear_ring).as_text
    end
  end

end
