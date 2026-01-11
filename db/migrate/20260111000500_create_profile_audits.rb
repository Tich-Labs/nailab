class CreateProfileAudits < ActiveRecord::Migration[8.1]
  def change
    create_table :profile_audits do |t|
      t.bigint :user_profile_id, null: false
      t.bigint :admin_id, null: false
      t.string :action, null: false
      t.text :reason
      t.timestamps
    end

    add_index :profile_audits, :user_profile_id
    add_index :profile_audits, :admin_id
  end
end
