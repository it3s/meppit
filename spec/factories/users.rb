FactoryGirl.define do
  factory :user do
    name "John"
    sequence(:email)   { |n| "john#{n}@doe.com" }
    password "abcdef"
    language "en"
    interests ["dev", "ruby", "rails"]
    after(:create) { |obj| obj.activate! }
  end

  factory :pending_user, class: User do
    name "John"
    sequence(:email)   { |n| "john#{n}@doe.com" }
    password "abcdef"
    language "en"
    interests ["dev", "ruby", "rails"]
    activation_token "blablablablabla"
    activation_state "pending"
  end
end
