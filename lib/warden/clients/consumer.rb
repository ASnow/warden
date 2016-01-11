module Warden
  module Clients
    class Consumer
      def initialize ip, user
        EM.epoll
        EM.run do
          conn = EventMachine::WebSocketClient.connect("ws://#{ip}:8080/")
          conn.callback do
            puts "Open socket"
            conn.send_msg JSON.dump ["login", user]
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
