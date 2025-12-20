# db/seeds.rb

# Refactor seed helpers into a module for better modularity and reusability
module SeedHelpers

  SEED_PASSWORD = ENV.fetch("SEED_PASSWORD", "ChangeMe123!ChangeMe123!")

  def self.safe_assign(record, attrs)
    allowed = record.class.column_names
    attrs.each do |k, v|
      record.public_send("#{k}=", v) if allowed.include?(k.to_s)
    end
  end
end


# Seed hero slides
puts "🌱 Seeding hero slides..."
hero_slides_data = [
  {

    # Seeding disabled. All content will be entered manually via the admin dashboard or UI.
    puts "✅ Seeding skipped. Ready for manual content entry."
    cta_text: "Join the Network",
