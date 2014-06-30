module UsersHelper
  def tools(user)
    (current_user == user ? [:edit, :settings] : []) + [:star, :flag]
  end
end
