class AddDisplayOrderToTestimonials < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:testimonials, :display_order)
      add_column :testimonials, :display_order, :integer, default: 0, null: false
    end

    unless index_exists?(:testimonials, :display_order)
      add_index :testimonials, :display_order
    end
  end
end
