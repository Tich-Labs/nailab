class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:messages)

    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.text :content

      t.timestamps
    end
  end
end
