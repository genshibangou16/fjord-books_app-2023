class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.integer :source_id, null: false
      t.integer :target_id, null: false

      t.timestamps
    end

    add_index :mentions, [:source_id, :target_id], unique: true
    add_foreign_key :mentions, :reports, column: :source_id, on_delete: :cascade
    add_foreign_key :mentions, :reports, column: :target_id, on_delete: :cascade
  end
end
