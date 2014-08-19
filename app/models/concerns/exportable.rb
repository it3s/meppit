module Exportable
  extend ActiveSupport::Concern

  included do
    def serialize(_format)
      hash = active_model_serializer.new(self).serializable_hash
      case _format
        when :json    then hash.to_json
        when :xml     then hash.to_xml
        when :csv     then csv_from_hash(hash)
        when :geojson then location_geojson
      end
    end

    private

      def csv_from_hash(hash)
        columns = hash.keys
        CSV.generate do |csv|
          csv << columns
          csv << hash.values_at(*columns)
        end
      end

      # def self.to_csv(options = {})
      #   CSV.generate(options) do |csv|
      #     csv << column_names
      #     all.each do |product|
      #       csv << product.attributes.values_at(*column_names)
      #     end
      #   end
      # end
  end
end
