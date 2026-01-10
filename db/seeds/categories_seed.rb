puts 'Seeding categories and mapping programs to categories...'

categories = (defined?(PagesController) && PagesController.const_defined?(:PROGRAM_CATEGORIES)) ? PagesController::PROGRAM_CATEGORIES : [
  "Startup Incubation & Acceleration",
  "Masterclasses & Mentorship",
  "Funding Access",
  "Research & Development",
  "Social Impact Programs"
]

categories.each do |name|
  Category.find_or_create_by!(name: name)
end

# Map existing programs' string category to Category records
if Program.column_names.include?('category')
  Program.where.not(category: [ nil, '' ]).find_each do |p|
    cat = Category.find_by(name: p.category)
    if cat
      unless p.categories.include?(cat)
        p.categories << cat
      end
    end
  end
else
  puts 'Skipping mapping from legacy programs.category — column not present.'
end

puts 'Categories seeded and programs mapped.'
