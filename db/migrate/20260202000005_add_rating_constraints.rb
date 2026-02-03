class AddRatingConstraints < ActiveRecord::Migration[7.0]
  def up
    # Add column only if it doesn't already exist
    unless column_exists?(:ratings, :rating_score)
      add_column :ratings, :rating_score, :integer # Keep as separate column for validation
    end

    unless column_exists?(:ratings, :rated_at)
      add_column :ratings, :rated_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
    end

    # Remove duplicate ratings, keeping only the most recent one per user per resource
    # This prevents "duplicate key value violates unique constraint" errors
    if table_exists?(:ratings)
      execute <<-SQL
        DELETE FROM ratings r1 WHERE id NOT IN (
          SELECT MAX(id) FROM ratings r2
          WHERE r1.user_id = r2.user_id AND r1.resource_id = r2.resource_id
          GROUP BY r2.user_id, r2.resource_id
        )
      SQL
    end

    # Add unique index only if it doesn't exist
    unless index_exists?(:ratings, [ :user_id, :resource_id ])
      add_index :ratings, [ :user_id, :resource_id ], unique: true # Prevent duplicates
    end
  end

  def down
    # Remove the unique index if it exists
    if index_exists?(:ratings, [ :user_id, :resource_id ])
      remove_index :ratings, [ :user_id, :resource_id ]
    end

    # Remove columns if they exist
    if column_exists?(:ratings, :rated_at)
      remove_column :ratings, :rated_at
    end

    if column_exists?(:ratings, :rating_score)
      remove_column :ratings, :rating_score
    end
  end
end
