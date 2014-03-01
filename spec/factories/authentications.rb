FactoryGirl.define do
  factory :facebook_auth, class: Authentication do
    user
    provider "facebook"
    uid "blablabalbla"
  end

  factory :google_auth, class: Authentication do
    user
    provider "google"
    uid "blablabalbla"
  end
end
