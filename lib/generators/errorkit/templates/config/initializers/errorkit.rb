# Configure Errorkit to display custom error pages and deliver error notifications.
#
# To view the errors in development you must change config/environments/development.rb:
#
#     config.consider_all_requests_local = false
#
Errorkit.configure do
  config.errors_class = Error
  config.notifier_recipients = ["jeffrafter@gmail.com"]
  config.notifier_sender = ["errors@songsly.com"]
end
