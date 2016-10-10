Rails.application.routes.draw do
  root to: 'users#index'
  
  resources :users, only: [:index, :create,:new, :show]
  resource :session, only: [:create, :new, :destroy]
end
