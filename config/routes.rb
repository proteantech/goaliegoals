Goalie::Application.routes.draw do
  resources :goals do
    resources :logs
  end

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end