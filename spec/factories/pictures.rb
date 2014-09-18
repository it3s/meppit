FactoryGirl.define do
  factory :picture do
    association :object, factory: :geo_data
    association :author, factory: :user
    image File.open(File.join(Rails.root, 'app', 'assets', 'images', 'imgs', 'avatar-placeholder.png'))
    description "bla bla bla"
  end
end
