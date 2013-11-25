module Errorkit
  class ErrorsController < ActionController::Base
    before_filter :append_view_paths

    helper_method :error, :exception, :status_code, :status_text

    layout Errorkit.config.errors_layout

    def show
      begin
        render "errors/#{rescue_response}", status: status_code
      rescue ActionView::MissingTemplate
        render "errors/error", status: status_code
      end
    end

    protected

    def error
      @error ||= env['errorkit.error']
    end

    def exception
      @exception ||= env['action_dispatch.exception']
    end

    def status_code
      @status_code ||= ActionDispatch::ExceptionWrapper.new(env, exception).status_code
    end

    def status_text
      Rack::Utils::HTTP_STATUS_CODES.fetch(status_code, "Internal Server Error")
    end

    def rescue_response
      @rescue_response ||= ActionDispatch::ExceptionWrapper.rescue_responses[exception.class.name]
    end

    private

    def append_view_paths
      append_view_path Pathname.new(File.expand_path('../../../', __FILE__)).join('lib', 'generators', 'errorkit', 'templates', 'app', 'views')
    end
  end
end
