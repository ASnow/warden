module Warden
  module Clients
    class Publisher
      def initialize ip, port = 8080
        EM.epoll
        EM.run do
          conn = EventMachine::WebSocketClient.connect("ws://#{ip}:#{port}/")
          conn.callback do
            puts "Open socket"
            conn.send_msg JSON.dump ["warden"]
            yield conn
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
