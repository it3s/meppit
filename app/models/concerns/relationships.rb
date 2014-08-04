module Relationships
  extend ActiveSupport::Concern

  included do
    attr_accessor :relations_attributes

    def relations
      Relation.find_related(self.id)
    end

    def relations_values
      relations.map { |r| {id: r.id, target: related_with_name(r), type: relation_type(r) } }
    end

    private

    def related_with_name(r)
      _id = r.related_ids.first == self.id.to_s ? r.related_ids.second.to_i : r.related_ids.first.to_i
      _name = GeoData.select(:name).find(_id).name
      {id: _id, name: _name}
    end

    def relation_type(r)
      "#{r.rel_type}_#{relation_direction(r)}"
    end

    def relation_direction(r)
      _id = r.related_ids.first == self.id.to_s ? r.direction : swap_direction(r.direction)
    end

    def swap_direction(direction)
      (direction.to_sym == :dir) ? :rev : :dir
    end

  end

end
