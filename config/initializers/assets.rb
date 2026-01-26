# Include the builds directory in the asset paths and ensure the Tailwind build
# is precompiled so production can reference `asset_path('builds/tailwind.css')`.
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'builds')
Rails.application.config.assets.precompile += %w[ builds/tailwind.css ]
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "builds")
Rails.application.config.assets.precompile += %w[ builds/tailwind.css ]
