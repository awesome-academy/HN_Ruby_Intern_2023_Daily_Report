Rails.application.routes.draw do
  namespace :admin do
    scope "(:locale)", locale: /en|vi/ do
      root "home#index"
      get "/login", to: "sessions#new"
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
      post "/users/:id/active", to: "users#active", as: :user_active
      post "/users/:id/inactive", to: "users#inactive", as: :user_inactive

      resources :users, only: %i(index show)
    end
  end

  scope "(:locale)", locale: /en|vi/ do
    root "home#index"
    get "/signup", to: "accounts#new"
    post "/signup", to: "accounts#create"
    resources :accounts, only: %i(show)

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    get "library", to: "books#index"
  end
end
