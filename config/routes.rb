Meppit::Application.routes.draw do
  root "pages#frontpage"

  get  "language/:code" => "application#language", :as => :language

  get  "logout"   => "sessions#destroy", :as => :logout
  get  "login"    => "sessions#new",     :as => :login
  post "login"    => "sessions#create",  :as => :do_login

  post "oauth/:provider/callback"  => "authentications#callback"
  get  "oauth/:provider/callback"  => "authentications#callback"
  get  "oauth/:provider" => "authentications#oauth", :as => :auth_at_provider

  get  "tags/search" => "tags#search", :as => :tag_search

  resources :users do
    member do
      get :activate
      get :contributions
    end

    collection do
      get :created

      get  :forgot_password
      post :reset_password
      get  "edit_password/:token" => "users#edit_password", :as => :edit_password
      post :update_password
    end
  end

  concern :contributable do
    resources :contributors, :only => [:index]
  end

  resources :geo_data, :only => [:index, :show, :edit, :update], :concerns => [:contributable]

  resource :following, :only => [:create, :destroy]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, :at => "/letter_opener"
  end
end
