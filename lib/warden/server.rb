module Warden
  class Server
    # Запускам сервис. В качестве аргумента передаем хеш с ключами
    #    address: ip на котором стартуем сервер
    #    port: port на котором стартуем сервер
    def self.start options = {}
      EM.epoll
      EM.run {
        hallway =  Channels::Hallway.new

        EM::WebSocket.run(:host => options[:address], :port => options[:port]) do |ws|
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
