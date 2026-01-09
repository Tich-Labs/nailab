class AddIntroTitleToProgramsPages < ActiveRecord::Migration[8.1]
  def change
    add_column :programs_pages, :intro_title, :string
  end
end
