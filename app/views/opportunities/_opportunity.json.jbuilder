json.extract! opportunity, :id, :title, :description, :url, :deadline, :created_at, :updated_at
json.url opportunity_url(opportunity, format: :json)
