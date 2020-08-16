Rails.application.routes.draw do
  root to: 'application#index'
  namespace :v1 do
    resources :users, only: [:index, :create]
    resource :favorite
    resource :comment
    resource :comment_favorite
  end
end
