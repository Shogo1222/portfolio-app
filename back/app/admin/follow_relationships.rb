ActiveAdmin.register FollowRelationship do
  actions :all, except: %i[new create destroy edit]
end
