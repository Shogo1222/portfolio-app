Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'application#index'
  namespace :v1 do
    resource :users
    resource :favorite
    resource :follow_relationship
    resource :visited_shop
    resource :comment
    resource :comment_favorite
    resource :invitation
    resource :notification
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

    resource :user_tags do
      member do
        get 'recent_tag'
      end
    end
  end
end
