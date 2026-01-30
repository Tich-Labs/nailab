#!/usr/bin/env bash
# Exit on any error
set -o errexit

# Install dependencies
bundle install



# Install Node dependencies
yarn install

# Precompile Tailwind CSS with the bundler-managed binary
bundle exec tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.tailwind.css --minify

# Precompile assets
bundle exec rails assets:precompile

# Optional: clean old assets (safe)
bundle exec rails assets:clean

# Run migrations (recommended on paid plans to move to pre-deploy, but fine here for free)
bundle exec rails db:migrate
