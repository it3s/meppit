class ContributingsListener

  def geo_data_updated(payload)
    save_contribution payload[:geo_data], payload[:current_user]
  end

  def map_updated(payload)
    save_contribution payload[:map], payload[:current_user]
  end

  private

    def save_contribution(contributable, contributor)
      if contributable.nil? || contributor.nil?
        Rails.logger.error "Error trying to save contribution: contributable=#{contributable} contributor=#{contributor}"
      else
        contributable.add_contributor contributor
      end
    end
end

