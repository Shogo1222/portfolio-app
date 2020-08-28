ActiveAdmin.register UserTag do
  actions :all
  permit_params :tag, :user_id
end
