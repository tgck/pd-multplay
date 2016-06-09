# -*- coding: utf-8 -*- 
# Unix Domain Socket/DGRAM で ソケットに書くプロセス

import socket, os, time
#BUF_SIZE = 4096

path = '/tmp/pd-local-read.sock'

fd = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)

while True:
	if os.path.exists(path):
		fd.sendto('dummy data', path)
	else:
		print '[Client] No socket to sendto. [%s]' % path
	time.sleep(3)



