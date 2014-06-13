module ContributableController
  extend ActiveSupport::Concern

  included do
    private

    def save_contribution
      contrib = Contributing.where(contributable_type: @object.class.name, contributable_id: @object.id, contributor_id: current_user.id).first_or_create
      contrib.save
    end
  end

  module ClassMethods
    def track_contributions
      after_action :save_contribution, :only => [:update]
    end
  end
end
