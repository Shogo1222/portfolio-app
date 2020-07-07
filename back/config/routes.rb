Rails.application.routes.draw do
  namespace :v1 do
    resources :users, only: [:index, :create]
    resource :favorite
    resource :comment
  end
end
