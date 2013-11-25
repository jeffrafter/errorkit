module Errorkit
  class Config
    attr_reader :ignore_agents, :ignore_exceptions

    def initialize(options = {})
      @ignore_exceptions = options[:ignore_exceptions]
      @ignore_agents = options[:ignore_agents]

      set_ignore_exceptions
      set_ignore_agents
    end

    protected

    def set_ignore_exceptions
      exceptions = @ignore_exceptions || []
      exceptions << ::ActiveRecord::RecordNotFound if defined? ::ActiveRecord::RecordNotFound
      exceptions << ::AbstractController::ActionNotFound if defined? ::AbstractController::ActionNotFound
      exceptions << ::ActionController::RoutingError if defined? ::ActionController::RoutingError
      @ignore_exceptions = exceptions.uniq
    end

    def set_ignore_agents
      agents = @ignore_agents || []
      agents += %w{Googlebot MSNBot Baiduspider Bing Inktomi Yahoo AskJeeves FastCrawler InfoSeek Lycos YandexBot NewRelicPinger Pingdom}
      @ignore_agents = /(#{agents.uniq.join('|')})/i
    end
  end
end
