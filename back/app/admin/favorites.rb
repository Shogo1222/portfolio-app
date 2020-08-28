ActiveAdmin.register Favorite do
  actions :all, except: %i[new create destroy edit]
end
