require "errorkit/version"
require 'errorkit/config'
require 'errorkit/ignorable_error'
require 'errorkit/errors_mailer'

begin
  require 'errorkit/sidekiq'
rescue LoadError
  # Sidekiq is not available
end

module Errorkit
  require 'errorkit/engine' if defined?(Rails)

  def self.configure(&block)
    config.instance_eval(&block)

    if defined?(Rails)
      Rails.application.config.exceptions_app = lambda do |env|
        Errorkit.server_error(env)
      end
    end
  end

  def self.config
    @config ||= Errorkit::Config.new
  end

  def self.server_error(env)
    exception = env['action_dispatch.exception']
    unless config.errors_class.nil? || config.ignore_exception?(exception) || config.ignore_agent?(env['HTTP_USER_AGENT'])
      begin
        request = ActionDispatch::Request.new(env)
        error = config.errors_class.create(
          server: server,
          environment: environment,
          version: application_version,
          exception: exception.class.to_s,
          message: exception.message,
          backtrace: clean_backtrace(exception),
          params: filtered_parameters(request).to_json,
          session: filtered_session(request).to_json,
          remote_ip: request.remote_ip.to_s,
          request_env: filtered_request_env(request).to_json,
          controller: (env['action_controller.instance'].controller_name rescue nil),
          action: (env['action_controller.instance'].action_name rescue nil),
          url: request.original_url)

        env['errorkit.notified'] = send_notification(error)
        env['errorkit.error'] = error
      rescue Errorkit::IgnorableError
        # noop
      end
    end
    config.errors_controller.action(:show).call(env)
  end

  def self.background_error(worker, payload, queue, exception)
    unless config.errors_class.nil? || config.ignore_exception?(exception)
      begin
        error = config.errors_class.create(
          server: server,
          environment: environment,
          version: application_version,
          exception: exception.class.to_s,
          message: exception.message,
          backtrace: clean_backtrace(exception),
          worker: worker.class.to_s,
          queue: queue.to_s,
          payload: payload.to_json
        )
        send_notification(error)
        error
      rescue Errorkit::IgnorableError
        # noop
      end
    end
  end

  def self.environment
    Rails.env.to_s if defined?(Rails)
  end

  def self.server
    @server ||= `hostname`.chomp rescue nil
  end

  def self.application_version
    @version ||= `cd #{Rails.root.to_s} && git rev-parse HEAD`.chomp rescue nil
  end

  def self.filtered_parameters(request)
    request.filtered_parameters
  end

  REQUEST_ENV = %w(SERVER_NAME PATH_INFO REMOTE_HOST HTTP_ACCEPT_ENCODING
    HTTP_USER_AGENT SERVER_PROTOCOL HTTP_CACHE_CONTROL HTTP_ACCEPT_LANGUAGE HTTP_HOST
    REMOTE_ADDR SERVER_SOFTWARE HTTP_KEEP_ALIVE HTTP_REFERER HTTP_COOKIE HTTP_ACCEPT_CHARSET
    REQUEST_URI SERVER_PORT GATEWAY_INTERFACE QUERY_STRING REMOTE_USER HTTP_ACCEPT
    REQUEST_METHOD HTTP_CONNECTION)

  def self.filtered_request_env(request)
    begin
      require 'action_dispatch/http/parameter_filter'
    rescue LoadError
      return {}
    end
    env = {}
    REQUEST_ENV.each do |var|
      env[var] = request.env[var]
    end
    param_filter = request.env.fetch("action_dispatch.parameter_filter")
    param_filter = ActionDispatch::Http::ParameterFilter.new(param_filter)
    param_filter.filter(env)
  end

  def self.filtered_session(request)
    begin
      require 'action_dispatch/http/parameter_filter'
    rescue LoadError
      return {}
    end
    session = request.session.dup
    session.delete(:session_id)
    session.delete(:_csrf_token)
    param_filter = request.env.fetch("action_dispatch.parameter_filter")
    param_filter = ActionDispatch::Http::ParameterFilter.new(param_filter)
    param_filter.filter(session.to_hash)
  end

  def self.clean_backtrace(exception)
    backtrace = Rails.backtrace_cleaner.send(:filter, exception.backtrace) if defined?(Rails) && Rails.respond_to?(:backtrace_cleaner)
    backtrace ||= exception.backtrace
    backtrace ||= []
    backtrace.join("\n")
  end

  def self.send_notification(error)
    return if config.mailer_recipients.blank? || config.mailer_sender.blank?

    # TODO, throttle
    config.errors_mailer.error_notification(error.id).deliver
  end
end
