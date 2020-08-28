ActiveAdmin.register Comment do
  actions :all, except: %i[new create]
  permit_params :comment
end
