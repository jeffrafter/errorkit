require 'action_mailer'

module Errorkit
  class ErrorNotifier < ActionMailer::Base
    self.mailer_name = 'errors'

    #Append application view path to the lookup context.
    self.append_view_path Rails.root.nil? ? "app/views" : "#{Rails.root}/app/views"  if defined?(Rails)
    self.append_view_path "#{File.dirname(__FILE__)}/views"

    attr_reader :error

    def server_error(error_id)
      build_mail(error_id)
    end

    def background_error(error_id)
      build_mail(error_id)
    end

    def javascript_error(error_id)
      build_mail(error_id)
    end

    protected

    def build_mail(error_id)
      @error = Error.find(error_id)

      mail(:to => recipients, :from => sender, :subject => subject) do |format|
        format.html { render "#{mailer_name}/errors" }
        format.text { render "#{mailer_name}/errors" }
      end
    end
  end
end
