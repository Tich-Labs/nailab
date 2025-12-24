class CreateActiveAdminComments < ActiveRecord::Migration[8.1]
  def self.up
    create_table :active_admin_comments, if_not_exists: true do |t|
      t.string :namespace
      t.text   :body
      t.references :resource, polymorphic: true
      t.references :author, polymorphic: true
      t.timestamps
    end
    add_index :active_admin_comments, [:namespace], if_not_exists: true
  end

  def self.down
    drop_table :active_admin_comments if table_exists?(:active_admin_comments)
  end
end
