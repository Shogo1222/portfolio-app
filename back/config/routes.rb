Rails.application.routes.draw do
  get '*unmatched_route' => 'application#render404'
  namespace :v1 do
    resources :users, only: [:index, :create]
    resource :favorite
    resource :comment
  end
end
