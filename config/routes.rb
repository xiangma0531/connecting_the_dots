Rails.application.routes.draw do
  devise_for :users
  root to: 'users#index'
  resources :dots, only: [:new, :create, :show, :edit, :update]
end
