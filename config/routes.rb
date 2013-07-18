Goalie::Application.routes.draw do
  resources :goals do
    resources :logs
  end

  post 'goals/:goal_id/logs/create_solo', to: 'logs#create_solo', as: 'logs_create_solo'

  devise_for :users
  #resources :users

  authenticated :user do
    root :to => 'goals#index'
  end

  root to: 'home#index'

  devise_scope :user do
    root to: "devise/sessions#new"
  end
end