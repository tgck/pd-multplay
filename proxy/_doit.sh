!/bin/bash

# 
# プロジェクトの検証に必要なプロセスを起動し、
# 簡易な疎通テストをおこないます
# 

function cleanProxy(){
	target=`ps -ef | grep python | grep webapp\.py | grep -v grep | awk '{print $2}'`
	if [ $target == "" ]; then
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

# プロキシを起動
cleanProxy;
(cd server; python webapp.py &)

# pd を起動
cleanApp;
(pd &)

# プロキシ-> pd の疎通確認
sleep 3;
testSendMessage;

# pd -> プロキシの疎通確認
# not implemented
testReceiveMessage;

# trap & cleaning
trap 'echo signal catch; cleanApp; cleanProxy; echo cleaning done.; exit' EXIT 

# Pretends a daemon.
while : 
do 
	sleep 10;
	:
done

