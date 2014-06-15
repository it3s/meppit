module ContributableController
  extend ActiveSupport::Concern

  included do
    private

    def _save_contribution
      contributable = _find_contributable
      #TODO: log the error if obj is nil
      contributable.add_contributor current_user unless contributable.nil?
    end
  end

  def _find_contributable 
    # Get the property that contains the object using controller name
    instance_variable_get("@#{params[:controller]}") ||
    instance_variable_get("@#{params[:controller].singularize}")
  end

  module ClassMethods
    def track_contributions
      after_action :_save_contribution, :only => [:update]
    end
  end
end
