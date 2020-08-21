Rails.application.routes.draw do
  root to: 'application#index'
  namespace :v1 do
    resource :users
    resource :user_tags do
      member do
        get 'recent_tag'
      end
    end
    resource :favorite
    resource :comment
    resource :comment_favorite
  end
end
