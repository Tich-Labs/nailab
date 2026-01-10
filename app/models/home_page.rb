# frozen_string_literal: true

class HomePage < ApplicationRecord
  has_one_attached :who_we_are_image
  has_one_attached :hero_image
end
