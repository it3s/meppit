module Mappable
  extend ActiveSupport::Concern

  included do
    has_many :mappings, dependent: :destroy
  end

  module ClassMethods
    def has_maps
      has_many :maps, through: :mappings
      define_method :maps_count do maps.count end
      define_method :add_map  do |map| mappings.create(map: map) end
    end

    def has_geo_data
      has_many :geo_data, through: :mappings
      define_method :geo_data_count do geo_data.count end
      define_method :add_geo_data do |geo_data| mappings.create(geo_data: geo_data) end
    end
  end
end
