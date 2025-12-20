class CreatePartners < ActiveRecord::Migration[8.1]
  include MigrationHelpers

  def change
    return if table_exists?(:partners)

    create_table :partners do |t|
      t.string :name, null: false
      t.string :logo_url
      t.string :website_url
      add_common_columns(t)
    end

    add_common_indexes(:partners)
  end
end
