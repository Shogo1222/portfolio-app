class RemoveShopIdFromInvitations < ActiveRecord::Migration[5.2]
  def change
    remove_column :invitations, :shop_id, :string
  end
end
