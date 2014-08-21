class ActivityListener

  def geo_data_created(payload)
    puts "on geo_data_created"
    save_activity payload[:geo_data], payload[:current_user]
  end

  def geo_data_updated(payload)
    puts "on geo_data_updated"
    save_activity payload[:geo_data], payload[:current_user]
  end


  def map_created(payload)
    puts "on map_created"
    save_activity payload[:map], payload[:current_user]
  end

  def map_updated(payload)
    puts "on map_updated"
    save_activity payload[:map], payload[:current_user]
  end

  def user_updated(payload)
    puts "user_updated"
    save_activity payload[:user], payload[:current_user]
  end

  private

    def save_activity(trackable, user)
      # trackable.create_activity :create, owner: current_user
      puts "SAVE ACTIVITY", trackable, user
    end
end

