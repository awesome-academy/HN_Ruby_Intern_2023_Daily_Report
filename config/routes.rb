Rails.application.routes.draw do
  namespace :admin do
    scope "(:locale)", locale: /en|vi/ do
      root "home#index"
      get "export/library", to: "home#export_library"

      devise_for :accounts, path: '', controllers: {
        sessions: "admin/sessions"
      }, skip: :registrations

      resources :authors, :genres, :publishers
      resources :books do
        member do
          get :amend, to: "books#amend_edit"
          get :authors, :genres
          patch :amend
        end
      end
      resources :users, only: %i(index show) do
        member do
          post :active, :inactive
        end
      end
      resources :borrows, only: %i(index show) do
        member do
          post :approve, :reject, :return, :remind
        end
        collection do
          get ":group", to: "borrows#index", as: "",
                        constraints: {group: /pending|history|borrowing/},
                        defaults: {group: :borrowing}
        end
      end
      resources :notifications, only: %i(index update) do
        collection do
          post "read_all", to: "notifications#read_all"
        end
      end
    end
  end

  scope "(:locale)", locale: /en|vi/ do
    root "home#index"
    devise_for :accounts, controllers: {
      sessions: "accounts/sessions",
      registrations: "accounts/registrations"
    }
    resources :accounts, only: %i(show edit update)

    resources :books, only: %i(index show), path: "library" do
      resources :book_comments, path: "comments"
    end
    resources :authors, only: %i(show)

    resource :carts, only: %i(show destroy)
    resources :borrow_items, only: %i(create destroy)
    resources :borrow_infos, only: %i(index show new create) do
      member do
        get "download", to: "borrow_infos#download"
        get "preview", to: "borrow_infos#preview"
        post "status_action", to: "borrow_infos#handle_status_action"
        patch "status_action", to: "borrow_infos#handle_status_action"
      end
    end

    resources :author_followers, only: %i(create destroy)

    resources :notifications, only: %i(index update) do
      collection do
        post "read_all", to: "notifications#read_all"
      end
    end
  end
end
