class AddWebsiteUrlAndPhotoUrlToTestimonials < ActiveRecord::Migration[6.1]
  def change
    unless column_exists?(:testimonials, :website_url)
      add_column :testimonials, :website_url, :string
    end
    unless column_exists?(:testimonials, :photo_url)
      add_column :testimonials, :photo_url, :string
    end
  end
end
