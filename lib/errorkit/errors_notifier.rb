require 'action_mailer'

module Errorkit
  class ErrorsNotifier < ActionMailer::Base
    self.mailer_name = 'errors'
    self.append_view_path Pathname.new(File.expand_path('../../../', __FILE__)).join('lib', 'generators', 'errorkit', 'templates', 'app', 'views')
    self.append_view_path Rails.root.join('app', 'views') if defined?(Rails)

    def error_notification(error_id)
      @error = Error.find(error_id)
      @recipients = Errorkit.config.notifier_recipients
      @sender = Errorkit.config.notifier_sender
      @subject = compose_subject(@error)

      mail(:to => @recipients, :from => @sender, :subject => @subject) do |format|
        format.html { render "#{mailer_name}/errors" }
        format.text { render "#{mailer_name}/errors" }
      end
    end

    protected

    def compose_subject(error)
      "[#{err.environment || 'Error'}] #{err.exception}: #{err.message}"
    end
  end
end
