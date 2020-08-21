class CreateFollowRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_relationships do |t|
      t.bigint :user_id, null: false
      t.bigint :following_user_id, null: false
      t.boolean :is_mutual_follow, null: false
      t.references :user, foreign_key: { on_delete: :cascade }, null: false
      t.references :following_user, foreign_key: { on_delete: :cascade, to_table: :users }, null: false

      t.timestamps
    end
  end
end
