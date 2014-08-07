module Relationships
  extend ActiveSupport::Concern

  included do
    attr_accessor :relations_attributes

    after_destroy :remove_relations_for_destroyed_related!

    def relations
      Relation.find_related(self.id)
    end

    def relations_values
      relations_with_relateds.map do |r|
        {
          id:       r.relation.id,
          target:   {id: r.related.id, name: r.related.name },
          type:     relation_type(r.relation),
          metadata: r.relation.metadata.nil? ? {} : r.relation.metadata.attributes,
        }
      end
    end

    def save_relations_from_attributes
      destroy_removed_relations
      relations_attributes.each do |r|
        rel = Relation.find_or_initialize_by id: r.id
        rel.assign_attributes related_ids: [self.id, r.target], rel_type: r.rel_type, direction: r.direction
        rel.upsert_metadata(r.metadata)
      end
    end

    private

    def remove_relations_for_destroyed_related!
      relations.destroy_all
    end

    def relations_with_relateds
      _relateds = get_all_relateds
      relations.map { |r| OpenStruct.new relation: r, related: _relateds[related_id_for_relation(r)] }
    end

    def related_id_for_relation(r)
      r.related_ids.first == self.id.to_s ? r.related_ids.second.to_i : r.related_ids.first.to_i
    end

    def get_all_relateds
      _ids = relations.map { |r| related_id_for_relation(r) }.uniq
      Hash[ *GeoData.select(:id, :name).where('id IN (?)', _ids).map { |g| [g.id, g] }.flatten ]
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

    def destroy_removed_relations
      old_ids = relations.pluck :id
      new_ids = relations_attributes.map(&:id).compact
      (old_ids - new_ids).each { |_id| Relation.find(_id).destroy }
    end

  end

end
