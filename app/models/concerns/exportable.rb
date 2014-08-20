module Exportable
  extend ActiveSupport::Concern

  included do
    def serialized_as(format)
      serializer = active_model_serializer.new(self)
      case format
        when :json    then serializer.to_json
        when :xml     then serializer.to_xml
        # when :csv     then self.class.generate_csv([hash])
        when :geojson then serializer.to_geojson  # TODO return simple feature, with embed featureCollection for map#geo_data
      end
    end

    def self.serialized_as(format)
      collection = all.map { |obj| active_model_serializer.new(obj).serializable_hash }
      case format
        when :json    then collection.to_json
        when :xml     then collection.to_xml
        when :csv     then generate_csv(collection)
        when :geojson then "" # TODO
      end
    end

    private

      def self.generate_csv(array)
        return "" if array.empty?

        columns = array[0].keys
        CSV.generate do |csv|
          csv << columns
          array.each { |hash| csv << hash.values_at(*columns).map { |v| csv_value v } }
        end
      end

      def self.csv_value(v)
        v.is_a?(Hash) || v.is_a?(Array) ? v.to_json : v
      end
  end
end
