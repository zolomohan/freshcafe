Rails.application.routes.draw do
  root to: "items#index"
  get "users", to: "users#index"
  
  post "make_admin", to: "users#make_admin"
  post "remove_admin", to: "users#remove_admin"
  
  post "make_clerk", to: "users#make_clerk"
  post "remove_clerk", to: "users#remove_clerk"

  devise_for :users
  devise_scope :user do
    get "login", to: "devise/sessions#new"
    delete "logout", to: "devise/sessions#destroy"
    get "signup", to: "devise/registrations#new"
  end

  resources :categories
  resources :items
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
