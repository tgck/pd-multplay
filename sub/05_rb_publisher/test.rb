#!/usr/bin/env ruby

require "socket"
load 'lib/colorize.rb'

# ドロップ対象となる ワードを定義する。
# 引数にメッセージを指定して検査する
def drop(msg)
  arr = ["pd key", "motion", "pd init"]
  return arr.any? {|w| msg.include?w }
end

# Gui => Proxy => Pd  ...  黄
def log_toPd(msg)
  str = "g=>  [" + msg.gsub(/;[\r\n]+/, ';' )+ "]"
  puts str.brown
end
# Gui <= Proxy <= Pd  ...  緑
def log_toPrimeGUI(msg)
  str = " <-p [" + msg.gsub(/\n/, '') + "]"
  puts str.green
end
# Nth Gui => Proxy => Pd 
def log_NthGuitoPd(msg, port, num)
  str = "g+> [" + port + "] " + msg
  case num % 8
  when 0..8
    puts port + ' ' + str.cyan
  end
end

### ##### ##### ##### ##### ##### ##### ###
### 最初に "wish pd-gui.tcl" などとして起動 ###
### ##### ##### ##### ##### ##### ##### ###

pguiport = ARGV[0] # prime gui : 最初に起動した GUI が待ち受けしているポート
puts "Connect to [GUI] of port[" + pguiport + "] as client." 

pguisock = TCPSocket.open("127.0.0.1", pguiport)

# GUI の管理
guipool = [pguisock]

# Pd からの接続を待つ
l_pdsock = TCPServer.open(8080)
puts "listening(pd) at 8080"

### ##### ##### ##### ##### ##### ##### ###
### 裏から "pd -guiport 8080" を叩くこと   ###
### ##### ##### ##### ##### ##### ##### ###

pdsock = l_pdsock.accept
puts "accepted(pd)"

# pd から Proxy へのメッセージを処理する
# pd ソケットに何かかかれたら、GUI(複数)のソケットに書く
pd_thread = Thread.new do
	loop do
		while buf = pdsock.gets
			# p " <-p [" + buf.gsub(/\n/, '') + "]"

			# 多重化された GUI に渡す
			for s in guipool do
				s.write(buf)
        log_toPrimeGUI('.... ' + buf)
			end
		end
	end
end

# GUIからProxyへのメッセージを処理する
# GUIソケットに何かかかれたら、Pd のソケットに書く。
gui_thread = Thread.new do
	loop do
		while buf = pguisock.gets


      # メッセージのチェック
      if drop(buf) then
        #p "g=>  [" + "xxxx" + "][DROP] " + buf
        #log_toPd('DROP ' + buf)
        log_toPd(buf)
        # NGワード持っているメッセージは送信しない
      else
        #p "g=>  [" + "xxxx" + "][PBL*] " + buf
        log_toPd(buf)
        # pd に向けて書く
        pdsock.write(buf)
      end
		end
	end
end

# 二番目以降の GUI に向かうスレッド。
lport = 18080
server = TCPServer.open(lport)
puts "listening new GUI applicants at port 18080"

while true

  Thread.start(server.accept) do |socket|
  	puts "new client accepted."
  	puts socket.peeraddr
    peerport = socket.peeraddr[1]
  	sleep(3)
  	puts "pd-multplay! now mimicing init gui message"
  	
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
        # puts "g+>p [" + peerport + "][DROP] " + buffer

        # NGワード持っているメッセージは送信しない
      else
        puts "g+> [" + peerport + "][PBL*] " + buffer
  		  # pd に向けて書く
      	pdsock.write(buffer)
      end
    end
    
    guipool.pop(socket)
    socket.close
    puts "client exited." 
  end
end

gui_thread.join 
pd_thread.join

server.close

