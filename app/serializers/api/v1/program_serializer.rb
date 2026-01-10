module Api
  module V1
    module Serializers
      class ProgramSerializer
        def initialize(program)
          @program = program
        end

        def to_h
          {
            id: program.id,
            title: program.title,
            slug: program.slug,
            description: program.description,
            content: program.content,
            cover_image_url: program.cover_image_url,
            category: (program.categories.map(&:name)),
            start_date: program.start_date,
            end_date: program.end_date,
            created_at: program.created_at
          }
        end

        private

        attr_reader :program
      end
    end
  end
end
