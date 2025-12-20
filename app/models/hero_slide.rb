class HeroSlide < ApplicationRecord
  has_one_attached :image

  def rails_admin_preview_path
    '/'
  end
end
