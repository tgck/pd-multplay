#!/usr/bin/env ruby

require "socket"
require "io/console"

# 単純なTCPクライアント
# 使い方:   test.rb 8080
# => ポート 8080 でリスンしているサーバプログラムに接続しに行く。

port = ARGV[0]
puts  "====Connect to port [" + port  + "] as client."

socket = TCPSocket.open("127.0.0.1", ARGV[0])

buffer =''
while (key = STDIN.getch) != "\C-c"
    puts key + " inspect: " + key.inspect
    buffer += key
    puts buffer
    #if (key == "\r" || key =="\n" || key == "a" )
    if (key == "\r" || key == "a" )
	socket.puts buffer
	buffer = ''
    end
end
puts "closing socket.. "	
socket.close
