Rails.application.routes.draw do
  root to: "home#index"

  post "refresh", controller: :refresh, action: :create
  post "registration", controller: :registration, action: :create
  post "login", controller: :login, action: :create # login
  delete "login", controller: :login, action: :destroy # logout

  namespace :api do
    namespace :v1 do
      resources :items
      resources :brands
    end
  end
end
