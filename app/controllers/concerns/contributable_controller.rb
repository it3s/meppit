module ContributableController
  extend ActiveSupport::Concern

  included do
    private

    def save_contribution
      obj = @data || @map
      contrib = Contributing.where(contributable_type: obj.class.name, contributable_id: obj.id, contributor_id: current_user.id).first_or_create
      contrib.save
    end
  end

  module ClassMethods
    def track_contributions
      after_action :save_contribution, :only => [:update]
    end
  end
end
