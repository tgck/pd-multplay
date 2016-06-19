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

      # 単一のGUI に渡す
      # pguisock.write(buf)

			# 多重化された GUI に渡す
			for s in guipool do
				s.write(buf)
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

# 二番目以降の GUI に向かうスレッド。
lport = 18080
server = TCPServer.open(lport)
p "listening new GUI applicants at port 18080"

while true

  Thread.start(server.accept) do |socket|
  	p "new client accepted."
  	p socket.peeraddr
  	sleep(3)
  	p "pd-multplay! now mimicing init gui message"
  	
  	socket.write <<-EOF
::pdwindow::post {canvas 24ae50, owner 0
}
::pdwindow::post {canvas 24ba60, owner 0
}
::pdwindow::post {canvas 24bda0, owner 0
}
pdtk_test
pdtk_test
pdtk_test
pdtk_test2 321 567
set pd_whichmidiapi 0
set pd_whichmidiapi 0
set ::tmp_path {}
set ::sys_searchpath $::tmp_path
set ::tmp_path {}
lappend ::tmp_path {/Users/tani/Library/Pd}
lappend ::tmp_path {/Library/Pd}
lappend ::tmp_path {./../extra}
set ::sys_staticpath $::tmp_path
set ::startup_flags {}
set ::startup_libraries {}
pdtk_pd_startup 0 45 4 {} {} {} {Monaco} normal
set pd_whichapi 4
set pd_whichmidiapi 0
EOF

# ここまで投げると GUI は canvas が開く
    
    guipool.push(socket) #? これでいいの？　pd から書いてもらうソケット。

    while buffer = socket.gets
    	p socket.peeraddr
    	p "+++ " + buffer
    	# socket.puts "200"
    	
		# pd に向けて書く
    	pdsock.write(buffer)
    	# TODO: 受信側も考慮する必要ある
    	# -> 一応、同報できるようにしたけど。このソケットに向かって、何か pd から初期化メッセージ送ってやらないとならんみたい。
    end
    
    guipool.pop(socket)
    socket.close
    p "client exited." 
  end
end

gui_thread.join 
pd_thread.join

server.close

