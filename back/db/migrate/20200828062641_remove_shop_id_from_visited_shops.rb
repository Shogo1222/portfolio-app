class RemoveShopIdFromVisitedShops < ActiveRecord::Migration[5.2]
  def change
    remove_column :visited_shops, :shop_id, :string
  end
end
