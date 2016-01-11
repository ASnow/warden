module Warden
  module Channels
    class Base     
      def call message, client
        prepare_call message, client
      end

      def prepare_call message, client
        message = JSON.load message
        process_call message, client
      end

      def process_call message, client
        on message, client
        self
      end

      def close client
      end
    end
  end
end

