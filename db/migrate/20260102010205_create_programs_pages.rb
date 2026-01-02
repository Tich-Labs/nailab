class CreateProgramsPages < ActiveRecord::Migration[8.1]
  def change
    create_table :programs_pages do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
