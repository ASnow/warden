module Warden
  module Channels
    class Exchange < Base
      def self.get user
        @pool ||= {}
        @pool[user] ||= new 
      end

      def initialize
        @main = EM::Channel.new
      end

      def bind client
        sid = @main.subscribe do |message|
          client.send message
        end
        client.instance_eval do
          @exchange_subscribe = sid
        end
      end
      
      def on message, client
        @main.push message
      end
      def close client
        channel = @main
        client.instance_eval do
          channel.unsubscribe @exchange_subscribe
        end        
      end
    end
  end  
end
