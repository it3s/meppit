module UsersHelper
  def user_tools(user)
    if current_user == user then [:edit, :settings] else [:star, :flag] end
  end
end
