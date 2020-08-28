ActiveAdmin.register LoggedShop do
  actions :all, except: %i[new create]
  permit_params :name, :catch, :capacity, :photo, :budget, :budget_memo, :mobile_access, :open, :non_smoking, :address
end
