class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: { on_delete: :cascade }, null: false
      t.references :logged_shop, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
