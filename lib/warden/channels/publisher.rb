module Warden
  module Channels
    class Publisher < Base
      def on message, client
        user, data = message
        channel = Exchange.get user
        channel.on data, client
      end
    end
  end  
end
