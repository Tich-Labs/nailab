class CreateProjectionAudits < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:projection_audits)
      create_table :projection_audits do |t|
        t.bigint :startup_id, null: false
        t.bigint :user_id
        t.date :period
        t.string :field
        t.text :old_value
        t.text :new_value
        t.string :reason
        t.timestamps
      end
      add_index :projection_audits, :startup_id
      add_index :projection_audits, :user_id
    end
  end
end
