class CreateTeamMembers < ActiveRecord::Migration[7.0]
  def change
    # Check if table already exists to prevent duplicate creation
    unless table_exists?(:team_members)
      create_table :team_members do |t|
        t.references :startup, null: false, foreign_key: true
        t.references :user, null: false, foreign_key: true
        t.integer :role, default: 2, null: false # 0=owner, 1=admin, 2=member
        t.boolean :is_founder, default: false
        t.datetime :joined_at, default: -> { 'CURRENT_TIMESTAMP' }
        t.text :bio

        t.timestamps
      end

      # Ensure unique team membership (one user per startup)
      add_index :team_members, [ :startup_id, :user_id ], unique: true

      # Index for quick lookups
      add_index :team_members, [ :role ]
      add_index :team_members, [ :is_founder ]
    end
  end
end
