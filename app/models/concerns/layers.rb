module Layers
  extend ActiveSupport::Concern

  included do
    attr_accessor :layers_attributes

    after_destroy :remove_layers_for_destroyed_map!

    def layers
      Layer.where map: self
    end

    def layers_values
      layers.map do |l|
        {
          id: l.id,
          name: l.name,
          visible: l.visible,
          fill_color: l.fill_color,
          stroke_color: l.stroke_color,
          position: l.position,
          rule: l.rule,
        }
      end
    end

    def save_layers_from_attributes
      destroy_removed_layers!
      layers_attributes.each do |l|
        layer = Layer.find_or_initialize_by id: l.id
        layer.assign_attributes map: self, name: l.name, fill_color: l.fill_color,
          stroke_color: l.stroke_color, visible: l.visible, rule: l.rule, position: l.position
        layer.save
      end
    end

    private

      def remove_layers_for_destroyed_map!
        layers.destroy_all
      end

      def destroy_removed_layers!
        old_ids = layers.pluck :id
        new_ids = layers_attributes.map(&:id).compact
        (old_ids - new_ids).each { |_id| Layer.find(_id).destroy }
      end
  end
end
