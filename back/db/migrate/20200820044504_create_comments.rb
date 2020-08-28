class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :comment, null: false
      t.string :image, null: true

      t.references :user, foreign_key: { on_delete: :cascade }, null: false
      t.references :logged_shop, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
