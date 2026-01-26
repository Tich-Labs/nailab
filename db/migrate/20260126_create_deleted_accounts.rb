class CreateDeletedAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :deleted_accounts do |t|
      t.string :email, null: false
      t.timestamps
    end
    add_index :deleted_accounts, :email, unique: true
  end
end
