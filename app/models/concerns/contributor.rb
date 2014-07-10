module Contributor
  extend ActiveSupport::Concern

  included do
    has_many :contributings, :foreign_key => :contributor_id, :dependent => :destroy

    def contributions(opts={}, order='updated_at DESC')
      contributings.order(order).where(opts).includes(:contributable).map(&:contributable)
    end

    def contributions_count
      contributions.count
    end

    def maps
      contributions({contributable_type: "Map"})
    end

    def maps_count
      maps.size
    end
  end
end
