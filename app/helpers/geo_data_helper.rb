module GeoDataHelper

  def data_tools(user)
    (current_user ? [:edit, :settings] : []) + [:history, :star, :flag]
  end
end
