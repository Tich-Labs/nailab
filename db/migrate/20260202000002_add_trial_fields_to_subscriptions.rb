class AddTrialFieldsToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    # Add columns only if they don't already exist
    unless column_exists?(:subscriptions, :trial_started_at)
      add_column :subscriptions, :trial_started_at, :datetime
    end

    unless column_exists?(:subscriptions, :trial_days)
      add_column :subscriptions, :trial_days, :integer, default: 5
    end

    # Add index only if it doesn't exist
    unless index_exists?(:subscriptions, :trial_started_at)
      add_index :subscriptions, :trial_started_at
    end
  end
end
