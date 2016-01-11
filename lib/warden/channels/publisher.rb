module Warden
  module Channels
    class Publisher < Base
      def on message, client
        p ['Publisher', message]
        user, data = message
        channel = Exchange.get user
        channel.on data, client
      end
    end
  end  
end
