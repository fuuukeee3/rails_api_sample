Rails.application.routes.draw do
  resources :users

  get 'rate_limit/index'
end
