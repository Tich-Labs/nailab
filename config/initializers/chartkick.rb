# Ensure Chartkick helpers are available in views
begin
  require "chartkick"
  ActionView::Base.include Chartkick::Helper
rescue LoadError => e
  Rails.logger.warn "Chartkick not loaded: "+ e.message
end
