class CreateCheckInShops < ActiveRecord::Migration[5.2]
  def change
    create_table :check_in_shops do |t|
      t.bigint :user_id, null: false
      t.string :shop_id, null: false
      t.references :user, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
