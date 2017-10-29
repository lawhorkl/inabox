require 'sidekiq/web'

Rails.application.routes.draw do
  resources :servers
  devise_for :users
  root 'servers#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
end
