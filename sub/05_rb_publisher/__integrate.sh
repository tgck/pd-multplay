#!/bin/bash
# 各スクリプト起動のシリアル化

#TMPFILE=./tmp.txt
TMPFILE=nohup.out
FIRST=./_doit.sh
SECOND=./test.rb
THIRD=./_next.sh
FOURTH=./_secondGui.sh

# Primal GUI
if [ -e $TMPFILE ]; then
	rm $TMPFILE;
fi

touch $TMPFILE
nohup $FIRST &
#( $FIRST  | grep --line-buffered port > $TMPFILE ) &
# $FIRST > $TMPFILE 2>&1 &

#### 問題, なぜか ファイルがスクリプトのなかから読めない.....

# Proxy
sleep 3
A=`grep port ${TMPFILE}`
sleep 3
echo "A " $A

PORTNUM=`grep port ${TMPFILE} | awk '{print $2; fflush()}'`
sleep 2
echo "Port: " $PORTNUM

sleep 1
#( $SECOND $PORTNUM ) &
$SECOND $PORTNUM 

# Pd Core
sleep 2
( $THIRD > /dev/null ) &

# Pd 2nd GUI
sleep 2
#( $FOURTH > /dev/null ) &

echo "ALL PROCESS UP NOW!"
