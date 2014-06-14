module Contributable
  extend ActiveSupport::Concern

  included do
    has_many :contributings, :foreign_key => :contributable_id
    has_many :contributors, :through => :contributings

    def contributors_count
      contributors.size
    end

    def add_contributor contributor
      contrib = Contributing.where(contributable_type: self.class.name, contributable_id: self.id, contributor_id: contributor.id).first_or_create
      contrib.save
    end
  end
end
