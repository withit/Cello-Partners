# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = false

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!




# more details are at https://support.google.com/a/answer/176600?hl=en#zippy=%2Cuse-the-gmail-smtp-server
# https://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration

#config.action_mailer.smtp_settings = {
#  address:              'smtp.gmail.com',
#  port:                 587,
#  domain:               'example.com',
#  user_name:            '<username>',
#  password:             '<password>',
#  authentication:       'plain',
#  enable_starttls_auto: true,
#  open_timeout:         5,
#  read_timeout:         5 }

config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
    :address => 'cello-com-au.mail.protection.outlook.com',
    :port => 25,
    :domain => 'cello.com.au'
}

#config.action_mailer.smtp_settings = {
#  :address => Setting.smtp_relay_address,
#  :port => Setting.smtp_relay_port,
#  :domain => Setting.smtp_relay_domain,
#  :user_name => Setting.smtp_relay_user_name,
#  :password => Setting.smtp_relay_password,
#  :enable_starttls_auto => Setting.smtp_relay_enable_starttls_auto,
#  :logger => Setting.smtp_relay_logger
#}
