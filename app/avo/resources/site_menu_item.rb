class Avo::Resources::SiteMenuItem < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :path, as: :text
    field :visible, as: :boolean
    field :position, as: :number
    field :location, as: :select, enum: ::SiteMenuItem.locations
  end
end
