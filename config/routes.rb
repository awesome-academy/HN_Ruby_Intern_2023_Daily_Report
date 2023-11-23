Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
        root "home#index"
    end

    root "home#index"
    get "/signup", to: "accounts#new"
    post "/signup", to: "accounts#create"
    resources :accounts, only: %i(show)
  end
end
