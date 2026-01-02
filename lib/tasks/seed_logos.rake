namespace :db do
  namespace :seed do
    desc "Seed Logo records from app/assets/images/logos"
    task logos: :environment do
      logos_dir = Rails.root.join("app", "assets", "images", "logos")
      unless File.directory?(logos_dir)
        puts "No logos directory found at #{logos_dir}"
        next
      end

      image_files = Dir.children(logos_dir).select { |f| f =~ /\.(png|jpe?g|gif|svg)$/i }.sort
      created = 0

      image_files.each_with_index do |filename, idx|
        basename = File.basename(filename, ".*")
        name = basename.tr("_", " ").titleize

        # Skip if a Logo with same name exists
        if Logo.exists?(name: name)
          puts "Skipping existing logo: #{name}"
          next
        end

        path = logos_dir.join(filename)

        begin
          logo = Logo.new(name: name, display_order: (Logo.maximum(:display_order) || 0) + 1, active: true)
          # read file into memory and attach via StringIO to avoid closed-stream issues
          content = File.binread(path)
          content_type = (defined?(Marcel) ? Marcel::MimeType.for(Pathname.new(path)) : nil)
          logo.image.attach(io: StringIO.new(content), filename: filename, content_type: content_type)
          logo.save!
          puts "Created logo #{logo.id}: #{name} (attached #{filename})"
          created += 1
        rescue => e
          puts "Failed to create logo #{name}: #{e.message}"
          logo.destroy if logo && logo.persisted?
        end
      end

      puts "Seeded #{created} logos."
    end
  end
end
