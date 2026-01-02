class AddWebsiteUrlToTestimonials < ActiveRecord::Migration[6.1]
  def change
    unless column_exists?(:testimonials, :website_url)
      add_column :testimonials, :website_url, :string
    end
  end
end
