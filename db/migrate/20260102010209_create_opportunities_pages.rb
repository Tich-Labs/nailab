class CreateOpportunitiesPages < ActiveRecord::Migration[8.1]
  def change
    create_table :opportunities_pages do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
