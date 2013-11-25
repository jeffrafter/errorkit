module Errorkit
  class Config
    attr_accessor \
      :ignore_agents,
      :ignore_exceptions,
      :errors_class,
      :errors_controller,
      :errors_layout,
      :notifier_recipients,
      :notifier_sender,
      :max_notifications_per_minute,
      :max_notifications_per_quarter_hour,
      :alert_threshold


    def initialize
      @errors_controller = Errorkit::ErrorsController
      @errors_layout = false
      @ignore_exceptions = []
      @ignore_exceptions << ::ActiveRecord::RecordNotFound if defined? ::ActiveRecord::RecordNotFound
      @ignore_exceptions << ::AbstractController::ActionNotFound if defined? ::AbstractController::ActionNotFound
      @ignore_exceptions << ::ActionController::RoutingError if defined? ::ActionController::RoutingError
      @ignore_agents = %w{Googlebot MSNBot Baiduspider Bing Inktomi Yahoo AskJeeves FastCrawler InfoSeek Lycos YandexBot NewRelicPinger Pingdom}
      @max_notifications_per_minute = 5
      @max_notifications_per_quarter_hour = 10
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
  end
end
