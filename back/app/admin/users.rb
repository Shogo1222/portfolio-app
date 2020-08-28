ActiveAdmin.register User do
  actions :all, except: %i[new create]
  permit_params :name, :image
end
