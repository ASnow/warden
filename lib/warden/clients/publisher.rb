module Warden
  module Clients
    class Publisher
      def initialize ip
        EM.epoll
        EM.run do
          conn = EventMachine::WebSocketClient.connect("ws://#{ip}:8080/")
          conn.callback do
            conn.send_msg JSON.dump ["warden"]
          end

          conn.errback do |e|
            puts "Got error: #{e}"
          end

          conn.stream do |msg|
            puts "<#{msg}>"
            if msg.data == "done"
              conn.close_connection
            end
          end

          conn.disconnect do
            puts "gone"
            EM::stop_event_loop
          end
        end
      end
    end
  end
end
