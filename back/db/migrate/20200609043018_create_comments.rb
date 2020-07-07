class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :user_id
      t.string :user_name
      t.string :shop_id
      t.string :comment

      t.timestamps
    end
    end
end
