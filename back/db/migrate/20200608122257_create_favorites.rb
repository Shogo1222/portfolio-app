class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.string :user_id
      t.string :shop_id

      t.timestamps
    end

    add_index :favorites, [:user_id, :shop_id], unique: true
  end
end
