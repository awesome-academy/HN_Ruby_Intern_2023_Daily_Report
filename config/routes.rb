Rails.application.routes.draw do
  namespace :admin do
    scope "(:locale)", locale: /en|vi/ do
      root "home#index"
      get "/login", to: "sessions#new"
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
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
  end
end
