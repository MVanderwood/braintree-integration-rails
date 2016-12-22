Rails.application.routes.draw do
  resources :payments, only: [:show, :new, :create]
end
