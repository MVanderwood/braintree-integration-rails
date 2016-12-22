Rails.application.routes.draw do
  root 'payments#new'

  resources :payments, only: [:show, :new, :create]
end
