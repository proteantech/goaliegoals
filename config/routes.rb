Goalie::Application.routes.draw do
  resources :goals do
    resources :logs
  end

  devise_for :users
  resources :users

  authenticated :user do
    root :to => 'goals#index'
  end
  devise_scope :user do
    root to: "devise/sessions#new"
  end
end