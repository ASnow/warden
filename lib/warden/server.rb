module Warden
  class Server
    def self.start
      EM.epoll
      EM.run {
        hallway =  Channels::Hallway.new

        EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
          ws.onopen { |handshake|
            puts "WebSocket connection open"
            @channel = hallway

            ws.onmessage { |msg|
              @channel = @channel.call msg, ws
            }

            ws.onclose {
              @channel.close ws
            }
          }
        end
      }
    end
  end
end
