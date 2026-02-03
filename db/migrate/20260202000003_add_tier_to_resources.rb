class AddTierToResources < ActiveRecord::Migration[7.0]
  def change
    # Add columns only if they don't already exist
    unless column_exists?(:resources, :tier)
      add_column :resources, :tier, :integer, default: 0 # 0=free, 1=premium
    end

    unless column_exists?(:resources, :requires_subscription)
      add_column :resources, :requires_subscription, :boolean, default: false
    end

    # Add indexes only if they don't exist
    unless index_exists?(:resources, :tier)
      add_index :resources, :tier
    end

    unless index_exists?(:resources, :requires_subscription)
      add_index :resources, :requires_subscription
    end
  end
end
