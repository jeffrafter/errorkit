require 'resque'

# Only connect if Resque exists
if defined?(::Resque)
  module Resque::Failure
    class Errorkit < Base
      def self.count
        Stat[:failed]
      end

      def save
        ::Errorkit.background_error(worker, payload, queue, exception)
      end
    end
  end
end
