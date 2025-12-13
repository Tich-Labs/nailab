class Avo::Resources::MentorshipSession < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :mentorship_request, as: :belongs_to
    field :date, as: :date_time
    field :duration, as: :number
    field :notes, as: :textarea
    field :feedback, as: :textarea
    field :rating, as: :number
  end
end
