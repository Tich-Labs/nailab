class Avo::Resources::Testimonial < Avo::BaseResource
  self.title = :name
  self.model_class = ::Testimonial

  def fields
    field :id, as: :id
    field :name, as: :text
    field :quote, as: :textarea
    field :avatar, as: :file
    field :visible, as: :boolean
    field :position, as: :number
  end
end
