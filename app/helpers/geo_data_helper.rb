module GeoDataHelper

  def data_tools(data=nil)
    (current_user ? [:edit] : []) + [:star, :history, :flag, :delete]
  end
end
