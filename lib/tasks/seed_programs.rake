# lib/tasks/seed_programs.rake
namespace :db do
  desc "Seed programs only (loads db/seeds/programs.rb)"
  task seed_programs: :environment do
    seed_file = Rails.root.join("db", "seeds", "programs.rb")
    unless File.exist?(seed_file)
      puts "No programs seed file found at #{seed_file}"
      next
    end

    puts "Seeding programs from #{seed_file}..."
    load seed_file
    puts "✅ Programs seed finished."
  end
end
