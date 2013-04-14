Goalie::Application.routes.draw do
  resources :goals


  resources :logs


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end