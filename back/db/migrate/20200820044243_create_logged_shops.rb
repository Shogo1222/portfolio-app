class CreateLoggedShops < ActiveRecord::Migration[5.2]
  def change
    create_table :logged_shops do |t|
      t.bigint :user_id, null: false
      t.string :action_from, null: false
      t.string :shop_id, null: false
      t.string :lat, null: true
      t.string :lat, null: true
      t.string :lng, null: true
      t.string :name, null: true
      t.string :catch, null: true
      t.string :capacity, null: true
      t.string :photo, null: true
      t.string :budget, null: true
      t.string :budget_memo, null: true
      t.string :mobile_access, null: true
      t.string :open, null: true
      t.string :non_smoking, null: true
      t.string :address, null: true

      t.references :user, foreign_key: { on_delete: :cascade }, null: false
      t.timestamps
    end
  end
end
