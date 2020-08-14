class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :user_id, null: false
      t.string :user_name, null: false
      t.string :shop_id, null: false
      t.string :comment, null: false
      t.string :image, null: true
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
    end
end
