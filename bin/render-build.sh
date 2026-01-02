#!/usr/bin/env bash
# Exit on any error
set -o errexit

# Install dependencies
bundle install

# Precompile assets
bundle exec rails assets:precompile

# Optional: clean old assets (safe)
bundle exec rails assets:clean

# Run migrations (recommended on paid plans to move to pre-deploy, but fine here for free)
bundle exec rails db:migrate
