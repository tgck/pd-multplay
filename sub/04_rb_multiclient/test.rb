#!/usr/bin/env ruby
require "socket"

# v3 マルチスレッド化して複数のクライアントからのレスポンスを返せるようにする
# http://qiita.com/nekogeruge_987/items/23312e53b15ebfeb0607
port = 8080
server = TCPServer.open(port)

while true
  Thread.start(server.accept) do |socket|
    p socket.peeraddr

    while buffer = socket.gets
      p socket.peeraddr
      p buffer
      socket.puts "200"
    end

    socket.close
  end
end

server.close

