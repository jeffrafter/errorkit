require "errorkit/version"
require 'errorkit/config'
require 'errorkit/ignorable_error'
require 'errorkit/errors_controller'
require 'errorkit/errors_notifier'

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
    unless config.ignore_exception?(exception) || config.ignore_agent?(env['HTTP_USER_AGENT'])
      begin
        request = ActionDispatch::Request.new(env)

        error = config.errors_class.create(
          server: server,
          environment: environment,
          version: application_version,
          exception: exception.class.to_s,
          message: exception.message,
          backtrace: clean_backtrace(exception),
          params: filtered_params(request).to_json,
          session: filtered_session(request).to_json,
          remote_ip: request.remote_ip,
          url: request.url,
          controller: (env['action_controller.instance'].controller_name rescue nil),
          action: (env['action_controller.instance'].action_name rescue nil)),

        env['errorkit.notified'] = error.notify!
        env['errorkit.error'] = error
      rescue Errorkit::IgnorableError
        # noop
      end
    end
    config.errors_controller.action(:show).call(env)
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

  def self.filtered_params(request)
    request.filtered_params
  end

  def self.filtered_session(request)
    session = request.session.dup
    session.delete(:session_id)
    session
  end

  def self.clean_backtrace(exception)
    backtrace = Rails.backtrace_cleaner.send(:filter, exception.backtrace) if defined?(Rails) && Rails.respond_to?(:backtrace_cleaner)
    backtrace ||= exception.backtrace
    backtrace ||= []
    backtrace.join("\n")
  end

end
