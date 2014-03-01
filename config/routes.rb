Meppit::Application.routes.draw do
  root 'pages#frontpage'

  get  "language/:code" => "application#language", :as => 'language'

  get  "logout"   => "sessions#destroy", :as => "logout"
  post "login"    => "sessions#create",  :as => "login"

  post "oauth/:provider/callback"  => "authentications#callback"
  get  "oauth/:provider/callback"  => "authentications#callback"
  get  "oauth/:provider" => "authentications#oauth", :as => :auth_at_provider

  resources :users, :only => [:new, :create] do
    member     { get :activate }
    collection { get :created  }
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, :at => "/letter_opener"
  end
end
