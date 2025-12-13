class Avo::Resources::MentorshipRequest < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user_id, as: :number
    field :mentor_id, as: :number
    field :request_type, as: :select, enum: ::MentorshipRequest.request_types
    field :status, as: :select, enum: ::MentorshipRequest.statuses
    field :topic, as: :text
    field :date, as: :date
    field :goal, as: :textarea
    field :startup_name, as: :text
    field :startup_bio, as: :textarea
    field :startup_stage, as: :text
    field :startup_industry, as: :text
    field :startup_funding, as: :text
    field :mentorship_needs, as: :textarea
    field :commitment_length, as: :text
    field :full_name, as: :text
    field :phone_number, as: :text
    field :target_market, as: :textarea
    field :preferred_mentorship_mode, as: :text
    field :funding_structure, as: :text
    field :total_funding, as: :text
    field :top_mentorship_areas, as: :text
    field :user, as: :belongs_to
    field :mentor, as: :belongs_to
  end
end
