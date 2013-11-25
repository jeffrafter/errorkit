require 'action_dispatch'

module Errorkit
  class Middleware

    attr_reader :config

    def initialize(app, options = {})
      @app = app
      @config = Errorkit::Config.new(options)
    end

    def call(env)
      @app.call(env)
    rescue Exception => exception
      unless ignore_exception?(exception) || ignore_agent?(env['HTTP_USER_AGENT'])
        begin
          error = Errorkit::Error.new(exception, env)
          error.notify
        rescue Errorkit::IgnorableError
          # noop
        end
        env['errorkit.notified'] = true
      end

      raise exception
    end

    private

    def ignore_exception?(exception)
      config.ignore_exceptions.include?(exception.class)
    end

    def ignore_agent?(agent)
      !!(agent =~ config.ignore_agents)
    end
  end
end
