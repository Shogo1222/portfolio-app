ActiveAdmin.register Notification do
  actions :all, except: %i[new create destroy]
  permit_params :is_opened
end
