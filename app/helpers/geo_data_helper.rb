module GeoDataHelper

  def data_tools(user)
    (current_user ? [:edit] : []) + [:star, :history, :flag, :delete]
  end
end
