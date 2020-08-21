class CreateShopTags < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_tags do |t|
      t.string :shop_id, null: false
      t.string :tag, null: false
      t.references :displayed_shop, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
