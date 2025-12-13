class Avo::Resources::MentorApplication < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :status, as: :select, enum: ::MentorApplication.statuses
    field :full_name, as: :text
    field :email, as: :text
    field :short_bio, as: :textarea
    field :current_role, as: :text
    field :experience_years, as: :select, enum: ::MentorApplication.experience_years
    field :has_advisory_experience, as: :boolean
    field :organization, as: :text
    field :industries, as: :tags
    field :mentorship_topics, as: :tags
    field :preferred_stages, as: :select, enum: ::MentorApplication.preferred_stages
    field :availability_hours, as: :select, enum: ::MentorApplication.availability_hours
    field :approach, as: :textarea
    field :motivation, as: :textarea
    field :mode, as: :select, enum: ::MentorApplication.modes
    field :rate, as: :number
    field :linkedin_url, as: :text
  end
end
