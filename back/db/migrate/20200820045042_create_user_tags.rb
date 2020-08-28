class CreateUserTags < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tags do |t|
      t.string :tag, null: false
      t.references :user, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
