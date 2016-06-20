#!/usr/bin/env ruby
require "socket"

# GUIから発せられたメッセージを、内容に応じて選別する 

def check(msg)
	msg.gsub(/a/, 'x')
end

# ドロップ対象となる ワードを定義する。
# 引数にメッセージを指定して検査する
def drop(msg)
  arr = ["pd key", "motion", "pd init"]
  return arr.any? {|w| msg.include?w }
end
		
### ##### ##### ##### ##### ##### ##### ###
### 最初に "wish pd-gui.tcl" などとして起動 ###
### ##### ##### ##### ##### ##### ##### ###

pguiport = ARGV[0] # prime gui : 最初に起動した GUI が待ち受けしているポート
p "Connect to [GUI] of port[" + pguiport + "] as client." 

pguisock = TCPSocket.open("127.0.0.1", pguiport)

# GUI の管理
guipool = [pguisock]

# Pd からの接続を待つ
l_pdsock = TCPServer.open(8080)
p "listening(pd) at 8080"

### ##### ##### ##### ##### ##### ##### ###
### 裏から "pd -guiport 8080" を叩くこと   ###
### ##### ##### ##### ##### ##### ##### ###

pdsock = l_pdsock.accept
p "accepted(pd)"

# pd から Proxy へのメッセージを処理する
# pd ソケットに何かかかれたら、GUI(複数)のソケットに書く
pd_thread = Thread.new do
	loop do
		while buf = pdsock.gets
			p " <-p [" + buf.gsub(/\n/, '') + "]"

			# 多重化された GUI に渡す
			for s in guipool do
				s.write(buf)
			end
		end
	end
end

# GUIからProxyへのメッセージを処理する
# GUIソケットに何かかかれたら、Pd のソケットに書く。
gui_thread = Thread.new do
	loop do
		while buf = pguisock.gets
			#p "g=>  [" + buf.gsub(/\n/, '') + "]"

      # メッセージのチェック
      if drop(buf) then
        p "g=>  [" + "xxxx" + "][DROP] " + buf
        # NGワード持っているメッセージは送信しない
      else
        p "g=>  [" + "xxxx" + "][PBL*] " + buf
        # pd に向けて書く
        pdsock.write(buf)
      end
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
    peerport = socket.peeraddr[1]
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
    
    guipool.push(socket)        # 新たに確率されたGUI側のソケットをプールに入れる

    while buffer = socket.gets  # 生成したソケットからの読み出し(このスレッドの担当するGUIで何かイベントがあったとき)
      # p socket.peeraddr
      if drop(buffer) then
        p "g+>p [" + peerport + "][DROP] " + buffer
        # NGワード持っているメッセージは送信しない
      else
        p "g+> [" + peerport + "][PBL*] " + buffer
  		  # pd に向けて書く
      	pdsock.write(buffer)
      end
    end
    
    guipool.pop(socket)
    socket.close
    p "client exited." 
  end
end

gui_thread.join 
pd_thread.join

server.close

