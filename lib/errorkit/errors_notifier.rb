require 'action_mailer'

module Errorkit
  class ErrorsNotifier < ActionMailer::Base
    before_filter :append_view_paths

    helper_method :error

    self.mailer_name = 'errors'

    def error_notification(error_id)
      @error = Error.find(error_id)

      mail(:to => notifier_recipients,
           :from => notifier_sender,
           :subject => notifier_subject) do |format|
        format.html { render "#{mailer_name}/notification" }
      end
    end

    protected

    def error
      @error
    end

    def notifier_recipients
      Errorkit.config.notifier_recipients
    end

    def notifier_sender
      Errorkit.config.notifier_sender
    end

    def notifier_subject
      "[#{error.environment || 'Error'}] #{error.exception}: #{error.message}"
    end

    def append_view_paths
      append_view_path Pathname.new(File.expand_path('../../../', __FILE__)).join('lib', 'generators', 'errorkit', 'templates', 'app', 'views')
    end
  end
end
