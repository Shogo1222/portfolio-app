ActiveAdmin.register ShopTag do
  actions :all
  permit_params :tag, :logged_shop_id
end
