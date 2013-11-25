module Errorkit
  class Error
    attr_accessor :exception, :options

    # Create a new error that can send notifications. Possible options
    # include:
    #
    #   :env When a server error occurs, the corresponding server env
    #   :worker When a background error occurs, the corresponding worker class
    #   :queue When a background error occurs, the corresponding worker queue
    #   :payload When a background error occurs, the corresponding job payload
    #   :subject_id A numeric id indicating which object was the subject of this error
    #   :subject_type A string indicating the class of the object which was the subject of this error
    #   :user_id A numeric id indicating the user
    def initialize(exception, options={})
      @exception = exception
      @options = options
    end

    def notify
      # Throttle the error
      # Persist the error
      # Notify
    end

    protected

    def environment
      Rails.environment.to_s if defined?(Rails)
    end

    def server
      @server ||= `hostname`.chomp rescue nil
    end

    def version
      @version ||= `git rev-parse HEAD`.chomp rescue nil
    end
  end
end
