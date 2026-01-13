class FixProgramCategories < ActiveRecord::Migration[8.1]
  def up
    # Map old invalid categories to valid ones
    category_mapping = {
      "social_impact" => "Social Impact Programs",
      "masterclasses_mentorship" => "Masterclasses & Mentorship",
      "incubation_acceleration" => "Startup Incubation & Acceleration",
      "funding_access" => "Funding Access",
      "research_development" => "Research & Development"
    }

    # Update programs with invalid categories
    Program.where(program_type: category_mapping.keys).each do |program|
      program.update_column(:program_type, category_mapping[program.program_type])
    end

    # Also handle any nil or empty categories
    Program.where(program_type: [ nil, "" ]).update_all(program_type: "Social Impact Programs")
  end

  def down
    # No need for down migration as this is a fix
  end
end
