class ActivityListener

  IGNORE_KEYS = ["updated_at", "created_at", "administrator_id"]
  REMOVE_VALS = ["avatar"]

  def geo_data_created(payload)
    save_activity payload, :geo_data, :create
  end

  def geo_data_updated(payload)
    save_activity payload, :geo_data, :update
  end

  def map_created(payload)
    save_activity payload, :map, :create
  end

  def map_updated(payload)
    save_activity payload, :map, :update
  end

  def user_updated(payload)
    save_activity payload, :user, :update
  end

  def followed(payload)
    save_activity payload, :object, :follow
  end

  def commented(payload)
    save_activity payload, :object, :comment
  end

  private

    def save_activity(params, key, action)
      trackable = params[key]
      changes = cleaned_changes(params)

      activity = trackable.create_activity action, owner: params[:current_user], parameters: {changes: changes}
      Notification.build_notifications(activity)
    end

    def cleaned_changes(params)
      return {} unless params[:changes]
      changes = params[:changes].except(*IGNORE_KEYS)
      REMOVE_VALS.each { |key| changes[key] = ["", ""] if changes[key] }
      changes
    end
end

