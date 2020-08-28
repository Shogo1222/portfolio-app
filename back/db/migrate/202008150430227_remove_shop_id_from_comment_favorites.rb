class RemoveShopIdFromCommentFavorites < ActiveRecord::Migration[5.2]
  def change
    remove_column :comment_favorites, :shop_id, :string
  end
end
