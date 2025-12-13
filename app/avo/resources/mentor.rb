class Avo::Resources::Mentor < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :bio, as: :textarea
    field :expertise, as: :text
    field :email, as: :text
    field :approved, as: :boolean
    field :available, as: :boolean

    # New detailed fields
    field :years_experience, as: :number
    field :current_affiliation, as: :text
    field :advisor_or_investor, as: :boolean
    field :mentorship_industries, as: :tags
    field :mentorship_areas, as: :tags
    field :preferred_stage, as: :select, options: ["Idea", "Early", "Growth", "Scaling"]
    field :availability_hours_per_month, as: :number
    field :mentorship_approach, as: :textarea
    field :motivation, as: :textarea
    field :mentorship_mode, as: :select, options: ["Virtual", "In-Person", "Both"]
    field :hourly_rate, as: :number, suffix: "USD"
    field :linkedin_url, as: :text
    field :website_url, as: :text

    field :mentorship_requests, as: :has_many
  end
end
