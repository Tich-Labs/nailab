# Prevent accidental destructive DB tasks running against production
# To override: set ENV['ALLOW_PROD_DB_CHANGE'] = '1'

namespace :safe do
  task :ensure_non_production do
    if Rails.env.production? && ENV["ALLOW_PROD_DB_CHANGE"] != "1"
      abort "Aborting: destructive DB task blocked in production.\n" +
            "If you really intend to run this in production, set ALLOW_PROD_DB_CHANGE=1 in the environment."
    end
  end
end

# Enhance common destructive tasks so the safety check runs first.
%w[db:drop db:reset db:setup].each do |task_name|
  if Rake::Task.task_defined?(task_name)
    Rake::Task[task_name].enhance([ "safe:ensure_non_production" ])
  end
end
