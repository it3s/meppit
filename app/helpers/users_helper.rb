module UsersHelper
  def user_tools(user)
    (current_user == user ? [:settings, :edit] : []) << :flag
  end
end
