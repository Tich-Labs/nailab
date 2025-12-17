class AddStructuredContentToStaticPages < ActiveRecord::Migration[7.0]
  def change
    add_column :static_pages, :structured_content, :jsonb, default: {}, null: false
  end
end
