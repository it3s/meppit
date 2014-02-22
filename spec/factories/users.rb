FactoryGirl.define do
  factory :user do
    name "John"
    sequence(:email)   { |n| "john#{n}@doe.com" }
    password "abcde"
    after(:create) { |obj| obj.activate! }
  end

  factory :pending_user, class: User do
    name "John"
    sequence(:email)   { |n| "john#{n}@doe.com" }
    password "abcde"
    activation_token "blablabla"
    activation_state "pending"
  end

  # factory :admin, class: User do
  #   name "Admin"
  #   admin true
  # end
end
