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
      resources :books, :authors, :genres, :publishers
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

    resources :books, only: %i(index show), path: "library"
    resources :authors, only: %i(show)

    resource :carts, only: %i(show destroy)
    resources :borrow_items, only: %i(create destroy)
    resources :borrow_infos, only: %i(index show new)
  end
end
