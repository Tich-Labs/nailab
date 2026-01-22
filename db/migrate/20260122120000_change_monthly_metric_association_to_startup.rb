class ChangeMonthlyMetricAssociationToStartup < ActiveRecord::Migration[8.0]
  def change
    # 1. Remove old reference
    remove_reference :monthly_metrics, :user, foreign_key: true

    # 2. Add new reference (currently allows NULLs)
    add_reference :monthly_metrics, :startup, foreign_key: true

    # 3. FIX: Assign a startup to existing rows
    # Replace 'Startup.first.id' with whatever logic makes sense for your app
    # If you have no startups yet, you must create one first!
    reversible do |dir|
      dir.up do
        if Startup.any?
          execute "UPDATE monthly_metrics SET startup_id = #{Startup.first.id}"
        else
          # If the table is empty, this won't matter. 
          # If not, you might want to delete orphan metrics:
          execute "DELETE FROM monthly_metrics" 
        end
      end
    end

    # 4. Now this will succeed because there are no more NULLs
    change_column_null :monthly_metrics, :startup_id, false
  end
end