module Contributable
  extend ActiveSupport::Concern

  included do
    def contributors
      _contributors.map(&:contributor)
    end

    def contributors_count
      _contributors.count
    end

    private

    def _contributors
      Contributing.where(contributable_type: self.class.name, contributable_id: id)
    end
  end
end
