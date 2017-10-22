require 'sidekiq/web'

Rails.application.routes.draw do
  resources :servers
  devise_for :users
  root 'homepage#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.htm
   mount Sidekiq::Web => '/sidekiq'
end
