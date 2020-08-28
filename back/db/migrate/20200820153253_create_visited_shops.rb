class CreateVisitedShops < ActiveRecord::Migration[5.2]
  def change
    create_table :visited_shops do |t|
      t.references :user, foreign_key: { on_delete: :cascade }, null: false
      t.references :logged_shop, foreign_key: { on_delete: :cascade }, null: false
      t.timestamps
    end
  end
end
