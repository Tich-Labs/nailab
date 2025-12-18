class CreateOpportunitySubmissions < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:opportunity_submissions)

    create_table :opportunity_submissions do |t|
      t.references :opportunity, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :details

      t.timestamps
    end
  end
end
