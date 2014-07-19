# Configure Errorkit to display custom error pages and deliver error notifications.
#
# To view the errors in development you must change config/environments/development.rb:
#
#     config.consider_all_requests_local = false
#
Errorkit.configure do
  # Many bots create errors spidering your site. You may want to ignore those. By
  # default the following bots are ignored:
  #
  #    config.ignore_agents = %w{
  #      Googlebot MSNBot Baiduspider Bing Inktomi Yahoo AskJeeves FastCrawler
  #      InfoSeek Lycos YandexBot NewRelicPinger Pingdom
  #    }
  #
  # If you do not want to ignore bots set the ignore_agents to an empty array
  #
  #    config,ignore_agents = []


  # Some exceptions should be expected and you don't want to be notified when they
  # occur. By default the following exceptions are ignored:
  #
  #    config.ignore_exceptions = [
  #      ActiveRecord::RecordNotFound,
  #      AbstractController::ActionNotFound,
  #      ActionController::RoutingError
  #    ]
  #
  # If you want to be notified of all errors set ignore_exceptions to an empty
  # array:
  #
  #    config.ignore_exceptions = []

  # The recipients you want to notify when there is an error. If you leave this
  # blank then notifications will not be sent.
  config.mailer_recipients = ["you@example.com"]

  # The sender of the error notifications. If you leave this blank then
  # notifications will not be sent.
  config.mailer_sender = ["errors@example.com"]

  # Overriding the default error pages allows you to customize their look
  # and feel but still have them served through your application. You can
  # override the view templates by creating new template within you
  # app/views/errors folder. If you want to change the layout used when
  # rendering the views, set:
  #
  #   config.errors_layout = 'application'
  #
  # By default, no layout is used (layout is false).

  # By default, Errorkit sends notifications with its own mailer. To override
  # this, set:
  #
  #    config.errors_mailer = MyMailer

  # By default, Errorkit responds to errors with its own controller. To override
  # this, set:
  #
  #    config.errors_controller = MyController


  # To persist errors, you must specify a class that acts like an ActiveRecord
  # model. If errors_class is not set, errors will not be persisted.
  config.errors_class = Error

  # Getting hundreds or thousands of error notifications is not fun. You
  # can set a max number of notifiactions per minute and per fifteen
  # minutes:
  #
  #    config.max_notifications_per_minute = 5
  #    config.max_notifications_per_quarter_hour = 10
  #
  # To turn off throttling set these values to nil


  # You may want to turn off formatting in the emails (it is only on if you
  # have the awesome_print gem installed):
  #
  #    config.format_errors = true
  #
  # To turn off formatting set this to false

  # It is possible to create alerts that occur only when the number of
  # errors per request exceeds a specific percentage.
  #
  #    config.alert_threshold = 0.4
  #
  # To turn off error rate alerts, set this to nil

  # If you are using resque you need to register errorkit
  #
  #    config.register_resque
end
