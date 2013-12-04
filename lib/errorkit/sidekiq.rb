require 'sidekiq'

module Errorkit
  class Sidekiq
    def call(worker, msg, queue)
      begin
        # Handle any setup
        yield
      rescue => ex
        Errorkit.background_error(worker, msg, queue, ex)
        raise
      ensure
        # Handle any cleanup
      end
    end
  end
end

# Only connect if Sidekiq
if defined?(::Sidekiq)
  ::Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      chain.add ::Errorkit::Sidekiq
    end
  end
end
