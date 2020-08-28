ActiveAdmin.register VisitedShop do
  actions :all, except: %i[new create destroy edit]
end
