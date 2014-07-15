module Mappable
  extend ActiveSupport::Concern

  included do
    has_many :mappings, dependent: :destroy
    has_many :maps, through: :mappings

    def maps_count
      maps.count
    end

    def add_to_map(map)
      mappings.create map: map
    end
  end
end
