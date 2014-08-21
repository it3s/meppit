module Exportable
  extend ActiveSupport::Concern

  included do
    def serialized_as(format)
      active_model_serializer.new(self).send(:"to_#{format}")
    end

    def self.serialized_as(format)
      collection = all.map { |obj| active_model_serializer.new(obj) }
      hashs_collection = collection.map &:serializable_hash
      case format
        when :json    then hashs_collection.to_json
        when :xml     then hashs_collection.to_xml
        when :csv     then ::CSVGenerator.generate hashs_collection
        when :geojson then feature_collection(collection.map &:geojson_feature_hash)
      end
    end

    private

      def self.feature_collection(collection)
        { "type" => "FeatureCollection", "features" => collection }.to_json
      end

  end
end
