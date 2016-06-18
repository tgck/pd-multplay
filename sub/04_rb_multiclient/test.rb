#!/usr/bin/env ruby
require "socket"

# Pd に対応することによる実装は sub/02_relay での実験が元
# Pd-GUI の あとで起動して
# Pd-GUI に接続する

### ##### ##### ##### ##### ##### ##### ###
### 最初に "wish pd-gui.tcl" などとして起動 ###
### ##### ##### ##### ##### ##### ##### ###

pguiport = ARGV[0] # prime gui : 最初に起動した GUI が待ち受けしているポート
p "Connect to port [" + pguiport + "] as client." 

pguisock = TCPSocket.open("127.0.0.1", pguiport)

# GUI の管理
guipool = [pguisock]

# Pd からの接続を待つ
l_pdsock = TCPServer.open(8080)
#p "listening(pd) at 8080 . fd[xx]".gsub(/xx/, pdlsock)
p "listening(pd) at 8080"

### ##### ##### ##### ##### ##### ##### ###
### 裏から "pd -guiport 8080" を叩くこと   ###
### ##### ##### ##### ##### ##### ##### ###

pdsock = l_pdsock.accept
p "accepted(pd)"

# pd とのソケットの処理をスレッドで
pd_thread = Thread.new do
	loop do
		while buf = pdsock.gets
			p "<-- [" + buf.gsub(/\n/, '') + "]"

			# GUI に渡す
			# pguisock.write(buf)
			for sock in guipool do
				sock.write(buf)
			end
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

# 二番目以降の GUI を扱うスレッド。
lport = 18080
server = TCPServer.open(lport)
p "listening new GUI applicants at port 18080"

while true

  Thread.start(server.accept) do |socket|
  	p "new client accepted."
  	p socket.peeraddr

  	# こんなメッセージじゃなくて、
  	socket.write('hoge!!!! now mimicing init gui message')
  	# pd-gui が初期化するようなやつ。メッセージは送れるけど、pd-gui は反応しない。
  	socket.write <<-EOF
::pdwindow::post {canvas 511110, owner 0
}
::pdwindow::post {canvas 40e640, owner 0
}
::pdwindow::post {canvas 40e980, owner 0}
pdtk_test
pdtk_test
pdtk_test
EOF

    while buffer = socket.gets
    	p socket.peeraddr
    	p "+++ " + buffer
    	# socket.puts "200"
    	
		# pd に向けて書く
    	pdsock.write(buffer)
    	# TODO: 受信側も考慮する必要ある
    	# -> 一応、同報できるようにしたけど。このソケットに向かって、何か pd から初期化メッセージ送ってやらないとならんみたい。
    end

    socket.close
    p "client exited." 
  end
end

gui_thread.join 
pd_thread.join

server.close

