class Session < ApplicationRecord
  belongs_to :user
  belongs_to :mentor

  def scheduled_at
    return nil if date.nil? || time.nil?
    DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec, time.zone || "+00:00")
  end
end
