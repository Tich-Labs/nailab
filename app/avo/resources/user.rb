class Avo::Resources::User < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :email, as: :text
    field :name, as: :text
    field :bio, as: :textarea
    field :avatar, as: :file
    field :sector, as: :text
    field :expertise, as: :text
    field :location, as: :text
    field :role, as: :text
    field :provider, as: :text
    field :uid, as: :text
    field :mentorship_requests, as: :has_many
  end
end
