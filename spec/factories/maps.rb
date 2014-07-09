FactoryGirl.define do
  factory :map do
    name "Open Data Organizations"
    tags ["open data", "open source", "ngo"]
    association :administrator, factory: :user
  end
end
