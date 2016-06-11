# -*- coding: utf-8 -*- 
# Unix Domain Socket/DGRAM で ソケットを受信するデーモンプロセス

# 以下のサイトを参考に作成
# https://siguniang.wordpress.com/2012/04/29/unix-domain-socket-address-types/
# https://gist.githubusercontent.com/quiver/4088062/raw/13f1f71b0b53dd3471eac96b43f30bd63d6f83d6/ud_ucase_sv.py

import socket, os
BUF_SIZE = 4096

#path = '/tmp/pd-local.sock'
path = '/tmp/pd-local-read.sock'

if os.path.exists(path):
	os.remove(path)

fd = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
fd.bind(path)
print "[Server] Making socket done. path[%s]" % path

while True:
	data, claddr = fd.recvfrom(BUF_SIZE)
	print 'recved [%d] bytes from [%s]' % (len(data), claddr)
	print data




