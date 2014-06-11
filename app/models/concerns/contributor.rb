module Contributor
  extend ActiveSupport::Concern

  included do
    has_many :contributings, :foreign_key => :contributor_id

    def contributed_objects(opts={}, order='updated_at DESC')
      contributings.order(order).where(opts).map(&:contributable)
    end

    def contributions_count
      contributed_objects.count
   end

    def maps_count
      contributed_objects({contributable_type: "Map"}).size
    end

  end
end
