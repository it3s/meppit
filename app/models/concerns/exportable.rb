module Exportable
  extend ActiveSupport::Concern

  included do
    def to_geojson
      location_geojson
    end

    def to_csv(options = {})
      columns = self.class.column_names
      CSV.generate(options) do |csv|
        csv << columns
        csv << attributes.values_at(*columns)
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
