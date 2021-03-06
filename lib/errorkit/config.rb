module Errorkit
  class Config
    attr_accessor \
      :ignore_agents,
      :ignore_exceptions,
      :errors_class,
      :errors_mailer,
      :errors_controller,
      :errors_layout,
      :mailer_recipients,
      :mailer_sender,
      :max_notifications_per_minute,
      :max_notifications_per_quarter_hour,
      :format_errors,
      :alert_threshold


    def initialize
      @errors_mailer = Errorkit::ErrorsMailer
      @errors_layout = false
      @ignore_exceptions = []
      @ignore_exceptions << ::ActiveRecord::RecordNotFound if defined? ::ActiveRecord::RecordNotFound
      @ignore_exceptions << ::AbstractController::ActionNotFound if defined? ::AbstractController::ActionNotFound
      @ignore_exceptions << ::ActionController::RoutingError if defined? ::ActionController::RoutingError
      @ignore_agents = %w{Googlebot MSNBot Baiduspider Bing Inktomi Yahoo AskJeeves FastCrawler InfoSeek Lycos YandexBot NewRelicPinger Pingdom}
      @max_notifications_per_minute = 5
      @max_notifications_per_quarter_hour = 10
      @format_errors = true
      @alert_threshold = 0.4
    end

    def config
      self
    end

    def ignore_exception?(exception)
      return false if @ignore_exceptions.nil? || @ignore_exceptions.length == 0
      @ignore_exceptions.include?(exception.class)
    end

    def ignore_agent?(agent)
      return false if @ignore_agents.nil? || @ignore_agents.length == 0
      @ignore_agent_re ||= /(#{@ignore_agents.join('|')})/i
      !!(agent =~ @ignore_agents_re)
    end

    def errors_controller
      return @errors_controller if defined?(@errors_controller)
      require 'errorkit/errors_controller'
      @errors_controller = Errorkit::ErrorsController
    end

    def register_resque
      if defined?(Rails) && defined?(Resque)
        if Rails.env.production? || Rails.env.staging?
          Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Errorkit]
          Resque::Failure.backend = Resque::Failure::Multiple
        end
      end
    end
  end
end
