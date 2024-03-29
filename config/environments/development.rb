Spabooker::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  Paperclip.options[:command_path] = "/usr/local/bin/"
  #Paperclip.options[:command_path] = "DYLD_LIBRARY_PATH='/Users/jch/Library/ImageMagick-6.6.3/lib' /Users/jch/Library/ImageMagick-6.6.3/bin"
  #  Paperclip.options[:image_magick_path] = "/usr/local/bin"
  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false
  
  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  
  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false
  config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log
  
  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  config.action_mailer.perform_deliveries = false
  config.action_mailer.default_url_options = { :host => "localhost:3000" }
  #  config.action_mailer.delivery_method = :smtp
  #  config.action_mailer.smtp_settings = {
  #  :enable_starttls_auto => true,
  #  :address        => "smtp.gmail.com",
  #  :port           => 587,
  #  :tls            => true,
  #  :domain         => "dailydigital.me",
  #  :user_name      => "",
  #  :password       => "",
  #  :authentication => :plain
  #  }
  
end
