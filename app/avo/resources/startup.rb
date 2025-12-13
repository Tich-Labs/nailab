class Avo::Resources::Startup < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :website, as: :text
    field :industry, as: :text
    field :founded_on, as: :date
    field :approved, as: :boolean
  end
end
