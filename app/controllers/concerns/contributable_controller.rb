module ContributableController
  extend ActiveSupport::Concern

  included do
    private

    def save_contribution
      obj = _get_object
      #TODO: log the error if obj is nil
      obj.add_contributor current_user unless obj.nil?
    end
  end

  def _get_object
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
