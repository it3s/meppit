module Geometry
  extend ActiveSupport::Concern

  included do
    scope :deselect, -> (*columns) do
      select(column_names - columns.map(&:to_s))
    end

    scope :with_geojson, -> (field=nil) do
      # Use the first geojson field defined using `geojson_field` by default.
      field = @geojson_fields.first unless field
      select("ST_AsGeoJSON(#{field}) as #{field}_geometry")
    end

    scope :nearest, -> (lon, lat, field=nil) do
      # Use the first geojson field defined using `geojson_field` by default.
      field = @geojson_fields.first unless field
      point = geofactory.point(lon, lat).as_text
      select("*, round(CAST(ST_Distance(ST_Centroid(\"#{table_name}\".\"#{field}\"), ST_GeomFromText('#{point}',4326)) As numeric),2) As distance")
      .where("NOT ST_IsEmpty(\"#{table_name}\".\"#{field}\")").order("distance")
    end

    scope :tile, -> (zoom, x, y, field=nil) do
      # Use the first geojson field defined using `geojson_field` by default.
      field = @geojson_fields.first unless field
      polygon = tile_as_polygon(zoom, x, y)
      # Gets GeoJSON directly from PostGIS because RGeo is very slow.
      with_geojson(field).deselect(field).where(
        "NOT ST_IsEmpty(\"#{table_name}\".\"#{field}\") AND (ST_Geomfromtext('#{polygon}', 4326) && \"#{table_name}\".\"#{field}\")"
      ).limit(nil)
    end
  end

  module ClassMethods

    def geofactory
      RGeo::Geographic.spherical_factory :srid => 4326
    end

    def geojson_field(*fields)
      @geojson_fields ||= []
      @geojson_fields.push(*fields)
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

    def tile_as_lat(zoom, y)
      n = 2.0 ** zoom
      lat_rad = Math::atan(Math::sinh(Math::PI * (1 - 2 * y / n)))
      lat = 180.0 * (lat_rad / Math::PI)
    end

    def tile_as_lon(zoom, x)
      n = 2.0 ** zoom
      lon = x / n * 360.0 - 180.0
    end

    def tile_as_polygon(zoom, x, y)
      north = tile_as_lat(zoom, y)
      south = tile_as_lat(zoom, y + 1)
      west  = tile_as_lon(zoom, x)
      east  = tile_as_lon(zoom, x + 1)
      nw = geofactory.point(west, north)
      ne = geofactory.point(east, north)
      sw = geofactory.point(west, south)
      se = geofactory.point(east, south)
      linear_ring = geofactory.linear_ring([nw, ne, se, sw])
      polygon = geofactory.polygon(linear_ring).as_text
    end
  end

end
