module Contributor
  extend ActiveSupport::Concern

  included do
    has_many :contributings, :foreign_key => :contributor_id

    def contributed_objects
      contributings.order('updated_at DESC').map(&:contributable)
    end

    def contributions_count
      contributed_objects.count
   end
  end
end
