module UsersHelper
  def user_tools(user)
    (current_user == user ? [:edit, :settings] : []) + [:star, :flag]
  end
end
