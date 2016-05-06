#!/bin/bash

#
# プロジェクトの検証に必要なプロセスを起動し、
# 簡易な疎通テストをおこないます
#

# Pd が読むソケット
UDS_READ_PATH=/tmp/pd-local-read.sock
# Pd が書くソケット
UDS_WRITE_PATH=/tmp/pd-local.sock

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
function testReceiveMessage(){
	# not implemented.
	:
}
function healthCheckPdRecv(){
	# pd の受信ソケットが生きているかどうかを確認
	echo "dummy 1 2 3;" | socat stdin unix-sendto:$UDS_READ_PATH
	echo "sending (socat)->(pd) result:[" $? "]"
}

# pd を起動
cleanApp;
(pd &)

# プロキシを起動
cleanProxy;
(cd server; python webapp.py &)

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
