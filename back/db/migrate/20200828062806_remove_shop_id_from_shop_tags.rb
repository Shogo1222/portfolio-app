class RemoveShopIdFromShopTags < ActiveRecord::Migration[5.2]
  def change
    remove_column :shop_tags, :shop_id, :string
  end
end
