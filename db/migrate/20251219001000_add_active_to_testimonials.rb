class AddActiveToTestimonials < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:testimonials, :active)
      add_column :testimonials, :active, :boolean, default: true, null: false
    end

    unless index_exists?(:testimonials, :active)
      add_index :testimonials, :active
    end
  end
end
