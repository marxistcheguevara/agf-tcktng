# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( main.css )
Rails.application.config.assets.precompile += %w( arena/style.css )
Rails.application.config.assets.precompile += %w( main.js )
Rails.application.config.assets.precompile += %w( arena/script.js )
Rails.application.config.assets.precompile += %w( scripts.js )
Rails.application.config.assets.precompile += %w( *.js )

Rails.application.config.assets.precompile += %w(active_admin.scss)
Rails.application.config.assets.precompile += %w(active_admin.js global.js)