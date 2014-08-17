module Mappable
  extend ActiveSupport::Concern

  included do
    has_many :mappings, dependent: :destroy
  end

  module ClassMethods
    def has_maps
      _define_mappings_for :maps
    end

    def has_geo_data
      _define_mappings_for :geo_data
    end

    private

      def _define_mappings_for(mapping_type)
        obj_ref = mapping_type.to_s.singularize.to_sym
        has_many mapping_type, through: :mappings
        define_method :"#{mapping_type}_count" do send(mapping_type).count end
        define_method :"add_#{obj_ref}" do |obj| mappings.create(obj_ref => obj) end
      end
  end
end
