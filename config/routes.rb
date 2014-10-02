Meppit::Application.routes.draw do
  root "pages#frontpage"

  get  "language/:code" => "application#language", as: :language

  get  "logout" => "sessions#destroy", as: :logout
  get  "login"  => "sessions#new",     as: :login
  post "login"  => "sessions#create",  as: :do_login

  post "oauth/:provider/callback"  => "authentications#callback"
  get  "oauth/:provider/callback"  => "authentications#callback"
  get  "oauth/:provider" => "authentications#oauth", as: :auth_at_provider

  post "search"      => "application#search", as: :search
  get  "tags/search" => "tags#search",        as: :tag_search

  get  "export/help" => "pages#export_help",  as: :export_help

  get  "notifications" => "notifications#notifications", as: :notifications
  post "notifications/read" => "notifications#read", as: :read_notifications

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

  concern :versionable do
    get "history" => "versions#history"
  end

  concern :downloadable do
    get "export" => "downloads#export", on: :member
    get "bulk_export" => "downloads#bulk_export", on: :collection
  end

  concern :has_media do
    patch "picture_upload" => "pictures#upload",  on: :member
    resources :pictures, only: [:show, :update, :destroy]
  end

  resources :users, except: [:destroy, :index],
                    concerns: [:contributor, :followable, :follower] do
    member do
      get :activate
      get "activity" => "activities#user_activity"
      patch :upload_avatar
      resource :settings, only: [:show, :update]
    end

    collection do
      get :created

      get  :forgot_password
      post :reset_password
      get  "edit_password/:token" => "users#edit_password", as: :edit_password
      post :update_password
    end
  end

  resources :geo_data, except:   [:destroy],
                       concerns: [:contributable, :followable, :versionable,
                                  :downloadable, :has_media] do
    member do
      get  :maps
      post :add_map
    end

    collection do
      get  :search_by_name
      post :bulk_add_map
    end
  end

  resources :maps, except:   [:destroy],
                   concerns: [:contributable, :followable, :versionable, :downloadable] do
    member do
      get  :geo_data
      post :add_geo_data
    end

    collection do
      get :search_by_name
    end
  end

  resources :versions, only: [:show] do
    post :revert, on: :member
  end

  resources :imports, only: [:create, :edit, :update] do
    get  :example, on: :collection
    post :load,    on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :geo_data, only: [:show, :index]
      resources :maps,     only: [:show, :index]
      resources :users,    only: [:show]
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
