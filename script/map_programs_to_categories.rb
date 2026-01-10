#!/usr/bin/env ruby
# One-off script to map existing Program records to Category records
# Usage:
#   bin/rails runner script/map_programs_to_categories.rb
# Options:
#   DRY_RUN=true  -- show what would be mapped without saving

dry_run = ENV['DRY_RUN'].present?

puts "Mapping programs to categories (dry_run=#{dry_run})"

mapping = {
  'Startup Incubation & Acceleration' => [ /incub/i, /accelerat/i, /incubator/i, /accel/i ],
  'Masterclasses & Mentorship' => [ /masterclass/i, /masterclass/i, /mentorship/i, /mentor/i, /workshop/i ],
  'Funding Access' => [ /fund/i, /grant/i, /investment/i, /investor/i, /funding/i ],
  'Research & Development' => [ /research/i, /r&d/i, /development/i, /prototype/i ],
  'Social Impact Programs' => [ /social/i, /impact/i, /community/i, /social enterprise/i ]
}

categories = Category.all.index_by(&:name)

assigned = 0
skipped = 0
unmapped = []

Program.where(active: true).find_each do |p|
  next if p.categories.any?

  text = [ p.program_type.to_s, p.title.to_s, p.short_summary.to_s ].join(' ').downcase
  matched = nil

  mapping.each do |cat_name, patterns|
    patterns.each do |pat|
      if text =~ pat
        matched = cat_name
        break
      end
    end
    break if matched
  end

  if matched
    cat = categories[matched]
    if cat.nil?
      puts "WARNING: Category '#{matched}' not found for program #{p.id} #{p.title}"
      unmapped << p
      next
    end
    puts "Assigning Program(#{p.id}) '#{p.title}' -> #{matched}"
    unless dry_run
      p.categories << cat
    end
    assigned += 1
  else
    unmapped << p
  end
end

puts "\nSummary: assigned=#{assigned}, skipped_with_existing=#{skipped}, unmapped=#{unmapped.size}"
if unmapped.any?
  puts "Unmapped examples:"
  unmapped.first(10).each { |p| puts "  #{p.id} - #{p.title}" }
end

puts "Done. To run without making changes set DRY_RUN=false or omit it (default will write)."
