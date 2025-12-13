class Avo::Resources::HomepageSection < Avo::BaseResource
  self.title = :title
  self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :subtitle, as: :text
    field :section_type, as: :select, enum: ::HomepageSection.section_types
    field :content, as: :trix
    field :cta_text, as: :text
    field :cta_url, as: :text
    field :position, as: :number
    field :visible, as: :boolean
  end
end
