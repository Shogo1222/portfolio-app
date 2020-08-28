ActiveAdmin.register Invitation do
  actions :all, except: %i[new create edit]
end
