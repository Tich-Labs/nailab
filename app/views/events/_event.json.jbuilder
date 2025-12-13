json.extract! event, :id, :title, :description, :date, :location, :registration_url, :created_at, :updated_at
json.url event_url(event, format: :json)
