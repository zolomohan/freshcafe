Rails.application.routes.draw do
  get 'carts/show'
  root to: "items#index"
  get "users", to: "users#index"
  
  post "make_admin", to: "users#make_admin"
  post "remove_admin", to: "users#remove_admin"
  
  post "make_clerk", to: "users#make_clerk"
  post "remove_clerk", to: "users#remove_clerk"

  post "order", to: "orders#create"
  get "order/:id", to: "orders#show"

  resource :cart, only: [:show] do
    put 'add/:id', to: 'carts#add', as: :add_to
    put 'remove/:id', to: 'carts#remove', as: :remove_from
    put 'increase/:id', to: 'carts#increase_quantity', as: :increase_quantity
    put 'decrease/:id', to: 'carts#decrease_quantity', as: :decrease_quantity
  end

  devise_for :users
  devise_scope :user do
    get "login", to: "devise/sessions#new"
    delete "logout", to: "devise/sessions#destroy"
    get "signup", to: "devise/registrations#new"
  end

  resources :categories
  resources :items
  resources :orders
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
