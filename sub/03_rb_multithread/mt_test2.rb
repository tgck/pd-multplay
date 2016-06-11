#!/usr/bin/env ruby

require "io/console"
require "socket"
 
# 単純なTCPサーバ。接続してきたクライアントのメッセージを、ログ出力する。
# http://www.geekpage.jp/programming/ruby-network/tcp-1.php
# TODO: 単純に
# 使い方:   test.rb --guiport 8080
# => ポート 8080 でリスンしているサーバプログラムに接続しに行く。

# [制約]先に、exec pd を抑止した Pd-GUI を起動しておくこと。
# そのときに確保したポートを使って、当スクリプトの引数を指定すること。

# Pd-GUIを起動する
#puts "Now, Exec Pd-GUI by command such as ... 'wish pd-gui.tcl'!!!"
#puts "And then, put 'a' to go ahead."
# exec("/usr/bin/wish ../../tcl/pd-gui.tcl")
# ls -l ../../tcl/pd-gui.tcl

# 引数
# サーバプログラムにクライアントとして接続。
# 引数で指定されたポート番号を使う
puts "====Connect to port [" + ARGV[0] + "] as client."

# Pd-GUIと通信するソケットを作成
c_sock = TCPSocket.open("127.0.0.1", ARGV[0])

# Pd からの接続を受け付けるソケットを作成して Pd を起動する
# Pd の起動は別のターミナルから実施すること
s0 = TCPServer.open(8080)
puts "====Now Waiting the Client(pd)."
l_sock = s0.accept

# クライアント(Pd)からのソケットの監視
pd_thread = Thread.new do
  loop do
    while buf = l_sock.gets
      puts "<---- [" + buf.gsub(/\n/, '') + "]"
      c_sock.write(buf)
      # puts "<     watching the socket for Client(Pd)..."
    end
  end
end

gui_thread = Thread.new do
  loop do
    while buf = c_sock.gets
      puts "----> [" + buf.gsub(/\n/, '') + "]"
      l_sock.write(buf)
      # puts "  > watching the socket for server(Pd-GUI)."
    end
  end
end

gui_thread.join 
pd_thread.join

while STDIN.getch != "q"
  puts STDIN.getch
end
