Rails.application.routes.draw do
  resources :payments, only: [:new, :create]
end
