class Avo::Resources::Program < Avo::BaseResource
  self.title = :title

  def fields
    field :id, as: :id
    field :title, as: :text
    field :summary, as: :textarea
    field :body, as: :trix
    field :category, as: :select, enum: ::Program.categories
    field :apply_link, as: :text
    field :image, as: :file
    field :visible, as: :boolean
    field :position, as: :number
  end
end
