# frozen_string_literal: true

class ContactUs < ApplicationRecord
  validates :name, :email, :subject, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
end
