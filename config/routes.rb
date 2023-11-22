Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
        root "home#index"
    end

    root "home#index"
  end
end
