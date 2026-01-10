namespace :programs do
  desc "List programs without categories and help with admin links"
  task without_categories: :environment do
    progs = Program.left_joins(:categories).where(categories: { id: nil })
    if progs.exists?
      puts "Programs without categories: #{progs.count}"
      progs.find_each do |p|
        admin_path = "/admin/program/#{p.id}"
        puts "##{p.id} - #{p.title.inspect} (slug: #{p.slug}) - admin: #{admin_path}"
      end
    else
      puts "All programs have categories (#{Program.count})"
    end
  end
end
