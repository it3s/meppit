module Contributable
  extend ActiveSupport::Concern

  included do

    def contributors
      User.joins(:contributings).where(contributings: _contributable_params)
    end

    def contributors_count
      contributors.size
    end

    def add_contributor(contributor)
      contrib = Contributing.where(_contributable_params.merge contributor_id: contributor.id).first_or_create
      contrib.save
    end

    private

    def _contributable_params
      {contributable_type: self.class.name, contributable_id: self.id}
    end
  end
end
