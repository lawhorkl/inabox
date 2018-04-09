require 'sidekiq/web'

Rails.application.routes.draw do
  resources :server_histories
  resources :servers
  devise_for :users
  root 'servers#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/servers/:id/charts/memory', to: 'charts#server_memory', as: 'server_memory_chart'
  get '/servers/:id/charts/cpu', to: 'charts#server_cpu', as: 'server_cpu_chart'
  get '/servers/:id/charts/disk', to: 'charts#server_disk', as: 'server_disk_chart'

  mount Sidekiq::Web => '/sidekiq'
end
