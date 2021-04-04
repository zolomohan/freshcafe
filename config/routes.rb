Rails.application.routes.draw do
  root to: "items#index"
  
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
