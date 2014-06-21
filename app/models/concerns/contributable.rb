module Contributable
  extend ActiveSupport::Concern

  included do

    def contributors
      User.joins(:contributings).where(contributings: {contributable_type: self.class.name, contributable_id: self.id})
    end

    def contributors_count
      contributors.size
    end

    def add_contributor contributor
      contrib = Contributing.where(contributable_type: self.class.name, contributable_id: self.id, contributor_id: contributor.id).first_or_create
      contrib.save
    end
  end
end
