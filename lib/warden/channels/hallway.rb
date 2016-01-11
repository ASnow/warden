module Warden
  module Channels
    class Hallway < Base
      def initialize
        @main = EM::Channel.new
      end

      def process_call message, client
        on(message, client)
      end
      
      def on message, client
        p ['Hallway', message]
        command, param = message
        if command == 'login'
          channel = Exchange.get param
          channel.bind client
          channel
        elsif command == 'warden'
          Publisher.new
        else
          client.send "wrong command: #{command}"
          self
        end
      end
    end
  end  
end
