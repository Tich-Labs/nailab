class AddAuthorNameToTestimonials < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:testimonials, :author_name)
      add_column :testimonials, :author_name, :string, default: "", null: false
    end
  end
end
