ActiveAdmin.register CommentFavorite do
  actions :all, except: %i[new create destroy edit]
end
