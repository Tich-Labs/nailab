#!/bin/bash
set -euo pipefail

# Run Tailwind CSS in watch mode.
# Usage: ./bin/tailwindcss-watch.sh

cd "$(dirname "$0")/.."

tailwindcss \
	-i app/assets/stylesheets/application.tailwind.css \
	-o app/assets/stylesheets/application.css \
	--watch
