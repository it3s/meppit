module ContributableController
  extend ActiveSupport::Concern

  included do
    private

    def save_contribution contributable = nil, contributor = nil
      contributable ||= _find_contributable
      contributor ||= current_user
      #TODO: log the error if obj is nil
      contributable.add_contributor contributor unless contributable.nil? or contributor.nil?
    end
  end

  def _find_contributable
    # Get the property that contains the object using controller name
    instance_variable_get("@#{params[:controller]}") ||
    instance_variable_get("@#{params[:controller].singularize}")
  end

  module ClassMethods
    def track_contributions
      after_action :save_contribution, :only => [:update]
    end
  end
end
