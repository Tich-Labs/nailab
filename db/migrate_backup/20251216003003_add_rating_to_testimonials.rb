class AddRatingToTestimonials < ActiveRecord::Migration[8.1]
  def change
    add_column :testimonials, :rating, :integer, default: 5, null: false
  end
end
