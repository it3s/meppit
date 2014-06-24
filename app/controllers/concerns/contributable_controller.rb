module ContributableController
  extend ActiveSupport::Concern

  included do
    private

    def save_contribution(contributable = nil, contributor = nil)
      contributable ||= _find_contributable
      contributor   ||= current_user
      if contributable.nil? || contributor.nil?
        logger.error "Error trying to save contribution: contributable=#{contributable} contributor=#{contributor}"
      else
        contributable.add_contributor contributor
      end
    end
  end

  def _find_contributable
    # Get the property that contains the object using controller name
    instance_variable_get("@#{params[:controller].singularize}")
  end
end
