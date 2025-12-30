class AddFieldsToPrograms < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :short_summary, :text
    add_column :programs, :program_type, :string
    add_column :programs, :status, :string, default: "completed"
    # hero_image will be handled by ActiveStorage (no direct column needed)
  end
end
