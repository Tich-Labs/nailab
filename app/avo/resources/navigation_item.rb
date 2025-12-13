class Avo::Resources::NavigationItem < Avo::BaseResource
  self.title = :title

  def fields
    field :id, as: :id
    field :title, as: :text
    field :path, as: :text
    field :location, as: :select, enum: { primary: "Primary", footer: "Footer" }
    field :visible, as: :boolean
    field :position, as: :number
  end
end
