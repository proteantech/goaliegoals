Goalie::Application.routes.draw do
  resources :goals do
    resources :logs
  end
  get 'details', to: 'static#details', as: 'details'
  post 'goals/create_solo', to: 'goals#create_solo', as: 'goals_create_solo'
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