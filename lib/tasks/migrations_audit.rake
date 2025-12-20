namespace :migrations do
  desc "Audit migrations for duplicate column/index additions"
  task audit: :environment do
    require 'active_record'

    migration_files = Dir.glob(Rails.root.join('db/migrate/*.rb'))
    operations = []

    migration_files.each do |file|
      content = File.read(file)
      filename = File.basename(file)

      # Find all add_column operations using simpler pattern matching
      content.each_line.with_index do |line, index|
        if line.include?('add_column')
          # Extract table and column from add_column :table, :column
          if match = line.match(/add_column\s*:(\w+),\s*:(\w+)/)
            operations << {
              type: :add_column,
              file: filename,
              table: match[1],
              column: match[2],
              line: index + 1
            }
          end
        end

        # Find all add_index operations
        if line.include?('add_index')
          # Extract table and column from add_index :table, :column or add_index :table, :column, ...
          if match = line.match(/add_index\s*:(\w+),\s*:?(\w+)/)
            operations << {
              type: :add_index,
              file: filename,
              table: match[1],
              column: match[2],
              line: index + 1
            }
          end
        end
      end
    end

    # Group by table, column, and type to find duplicates
    duplicates = operations.group_by { |op| [op[:table], op[:column], op[:type]] }
                           .select { |_, ops| ops.size > 1 }

    if duplicates.empty?
      puts "✅ No duplicate migration operations found!"
      exit 0
    else
      puts "❌ Found duplicate migration operations:"
      puts "=" * 60

      duplicates.each do |(table, column, type), ops|
        puts "\n🔍 #{type.to_s.upcase} #{table}.#{column} found in #{ops.size} migrations:"
        ops.each do |op|
          puts "  - #{op[:file]}:#{op[:line]}"
        end
      end

      puts "\n⚠️  WARNING: Duplicate operations may cause migration failures!"
      puts "   Consider adding existence checks (unless column_exists?/index_exists?)"
      exit 1
    end
  end
end