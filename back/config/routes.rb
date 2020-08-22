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
    resource :visited_shop
    resource :comment
    resource :comment_favorite
    resource :logged_shop do
      member do
        get 'recent_shop'
      end
    end
    resource :shop_tags do
      member do
        get 'recent_tag'
      end
    end
  end
end
