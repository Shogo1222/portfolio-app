class CreateCommentFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :comment_favorites do |t|
      t.string :user_id, null: false
      t.string :shop_id, null: false
      t.string :comment_id, null: false
      t.references :user, foreign_key: { on_delete: :cascade }, null: false
      t.references :comment, foreign_key: { on_delete: :cascade }, null: false
      t.timestamps
    end
    end
end
