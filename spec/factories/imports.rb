FactoryGirl.define do
  factory :import do
    association :user
    source File.open(File.join(Rails.root, 'spec', 'factories', 'import_test.csv'))
  end
end
