module Contributor
  extend ActiveSupport::Concern

  included do
    has_many :contributings, :foreign_key => :contributor_id

    def contributions(opts={}, order='updated_at DESC')
      Kaminari.paginate_array(contributings.order(order).where(opts).map(&:contributable))
    end

    def contributions_count
      contributions.count
   end

    def maps_count
      contributions({contributable_type: "Map"}).size
    end

  end
end
