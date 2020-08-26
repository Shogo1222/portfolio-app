class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.bigint :user_id, null: false
      t.bigint :to_user_id, null: false
      t.string :shop_id, null: false
      t.references :user, foreign_key: { on_delete: :cascade }, null: false
      t.references :to_user, foreign_key: { on_delete: :cascade, to_table: :users }, null: false
      t.references :logged_shop, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
