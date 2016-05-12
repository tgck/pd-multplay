#!/bin/bash

#
# プロジェクトの検証に必要なプロセスを起動し、
# 簡易な疎通テストをおこないます
#

# 注: 
# 	Pd を起動してから Python Proxy を起動する。
#   したがって、Pd の起動プロセス中の外部ソケットへの sendto は失敗する
#   のちに、再度実施すれば成功するはずなので気にしない

# Pd が読むソケット
UDS_READ_PATH=/tmp/pd-local-read.sock
# Pd が書くソケット
UDS_WRITE_PATH=/tmp/pd-local.sock

# ソケットファイルのチェック。存在していたら消去
function cleanSockets(){
	echo "cleaning sockets..."
	
	ls $UDS_READ_PATH  | grep ""; rm -f `ls $UDS_READ_PATH | grep ""`
	ls $UDS_WRITE_PATH | grep ""; rm -f `ls $UDS_WRITE_PATH | grep ""`
}
function cleanProxy(){
	target=`ps -ef | grep python | grep webapp\.py | grep -v grep | awk '{print $2}'`
	if [[ $target -eq "" ]]; then
		:
	else
		kill -9 $target;
	fi
	sleep 1;
}
function cleanApp(){
	killall pd 2> /dev/null;
	sleep 1;
}
function testSendMessage(){
	wget -q -O - http://localhost:8080/cmd?%22pd%20dsp%201%22 ;
}

function healthCheckProxyRecv(){
	# proxy の受信ソケットが生きているかどうかを確認
	echo "health check of proxy's receiving socket!" | socat stdin unix-sendto:$UDS_WRITE_PATH
}
function healthCheckPdRecv(){
	# pd の受信ソケットが生きているかどうかを確認
	echo ";" | socat stdin unix-sendto:$UDS_READ_PATH
	echo "sending (socat)->(pd) result:[" $? "]"
}

# pd を起動
cleanSockets;
cleanApp;
(pd &)

# プロキシを起動
cleanProxy;
(cd server; python webapp.py &)

healthCheckProxyRecv;

# プロキシ-> pd の疎通確認
#sleep 3;
#testSendMessage;

# pd -> プロキシの疎通確認
# not implemented
#testReceiveMessage;

# trap & cleaning
trap 'echo signal catch; cleanApp; cleanProxy; echo cleaning done.; exit' EXIT

# Pretends a daemon.
while :
do
	sleep 10;
	healthCheckPdRecv;
	:
done
