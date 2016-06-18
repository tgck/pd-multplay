#!/usr/bin/env ruby
require "socket"

# Pd に対応することによる実装は sub/02_relay での実験が元
# Pd-GUI の あとで起動して
# Pd-GUI に接続する
pguiport = ARGV[0] # prime gui : 最初に起動した GUI が待ち受けしているポート
p "Connect to port [" + pguiport + "] as client." 

pguisock = TCPSocket.open("127.0.0.1", pguiport)

# Pd からの接続を待つ
l_pdsock = TCPServer.open(8080)
#p "listening(pd) at 8080 . fd[xx]".gsub(/xx/, pdlsock)
p "listening(pd) at 8080"
## 裏から "pd -guiport 8080" を叩くこと

pdsock = l_pdsock.accept
p "accepted(pd)"

# pd とのソケットの処理をスレッドで
pd_thread = Thread.new do
	loop do
		while buf = pdsock.gets
			p "<-- [" + buf.gsub(/\n/, '') + "]"

			# GUI に渡す
			pguisock.write(buf)
		end
	end
end

# Pd-GUI とのソケットの処理をスレッドで
gui_thread = Thread.new do
	loop do
		while buf = pguisock.gets
			p "--> [" + buf.gsub(/\n/, '') + "]"

			# pd に渡す
			pdsock.write(buf)
		end
	end
end

gui_thread.join 
pd_thread.join

# v3 マルチスレッド化して複数のクライアントからのレスポンスを返せるようにする
# http://qiita.com/nekogeruge_987/items/23312e53b15ebfeb0607
lport = 18080
server = TCPServer.open(lport)

# while true
#   Thread.start(server.accept) do |socket|
#     p socket.peeraddr

#     while buffer = socket.gets
#       p socket.peeraddr
#       p buffer
#       socket.puts "200"
#     end

#     socket.close
#   end
# end

server.close

