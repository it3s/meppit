class << self
  def user_fixture
    puts "creating User"
    user = User.find_or_create_by(name: "Donald \"Quack\" Duck", email: "donald@duck.com")
    user.activation_state = "active"
    user.activation_token = nil
    user.about_me = "quack quack quaaaack quack"
    user.contacts = {"city" => "Patopolis"}
    user.interests = ["food", "quacking"]
    user.password = "1234567890"
    user.save
  end
end

user_fixture
