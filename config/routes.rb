Meppit::Application.routes.draw do
  root "pages#frontpage"

  get  "language/:code" => "application#language", as: :language

  get  "logout" => "sessions#destroy", as: :logout
  get  "login"  => "sessions#new",     as: :login
  post "login"  => "sessions#create",  as: :do_login
  get  "sessions/logged_in" => "sessions#logged_in", as: :logged_in

  post "oauth/:provider/callback"  => "authentications#callback"
  get  "oauth/:provider/callback"  => "authentications#callback"
  get  "oauth/:provider" => "authentications#oauth", as: :auth_at_provider

  post "search"      => "application#search", as: :search
  get  "tags/search" => "tags#search",        as: :tag_search

  concern :contributable do
    get "contributors" => "contributings#contributors"
  end

  concern :contributor do
    get "contributions" => "contributings#contributions"
    get "maps" => "contributings#maps"
  end

  concern :followable do
    resource :follow, controller: :followings, only: [:create, :destroy]
    get "followers" => "followings#followers"
  end

  concern :follower do
    get "following" => "followings#following"
  end

  resources :users, except: [:destroy, :index],
                    concerns: [:contributor, :followable, :follower] do
    member do
      get :activate
    end

    collection do
      get :created

      get  :forgot_password
      post :reset_password
      get  "edit_password/:token" => "users#edit_password", as: :edit_password
      post :update_password
    end
  end

  resources :geo_data, only: [:index, :show, :edit, :update, :maps],
                       concerns: [:contributable, :followable] do
    member do
      get  'maps'
      post 'add_to_map'
    end

    collection do
      get :search_by_name
    end
  end

  resources :maps, only: [:index, :show, :edit, :update, :geo_data],
                   concerns: [:contributable, :followable] do
    member do
      get  'geo_data'
      post 'add_data'
    end

    collection do
      get :search_by_name
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
