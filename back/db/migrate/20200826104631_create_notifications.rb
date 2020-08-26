class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.bigint :user_id, null: false
      t.boolean :is_opened, default: false
      t.string :action_from, null: false
      t.bigint :follow_relationship_id, default: 0
      t.bigint :invitation_id, default: 0

      t.references :user, foreign_key: { on_delete: :cascade }, null: false
      t.timestamps
    end
  end
end
