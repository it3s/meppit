FactoryGirl.define do
  factory :user do
    name "John"
    email  "john@doe.com"
    password 'abcde'
    # admin false
  end

  # factory :admin, class: User do
  #   name "Admin"
  #   admin true
  # end
end
