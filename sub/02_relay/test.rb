#!/usr/bin/ruby

require "socket"

# 単純なTCPサーバ。接続してきたクライアントのメッセージを、ログ出力する。
# http://www.geekpage.jp/programming/ruby-network/tcp-1.php
# TODO: 単純に
# 使い方:   test.rb --guiport 8080
# => ポート 8080 でリスンしているサーバプログラムに接続しに行く。

# 引数
puts "Connect to port [" + ARGV[0] + "] as client."

# サーバプログラムにクライアントとして接続。
# 引数で指定されたポート番号を使う
c_sock = TCPSocket.open("127.0.0.1", ARGV[0])


# ポート番号8080番で待ち受け
s0 = TCPServer.open(8080)

# クライアントからの接続を受け付ける
l_sock = s0.accept

# クライアントからのデータを最後まで受信する
# 受信したデータはコンソールに表示される
while buf = l_sock.gets
  p ".... forwarding ....[" + buf + "]"
  c_sock.write(buf) 
end

# クライアントとの接続ソケットを閉じる
sock.close

# 待ちうけソケットを閉じる
s0.close
