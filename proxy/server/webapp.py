# -*- coding: utf-8 -*-
from bottle import route, run, hook, request, response
from Queue import Queue, Empty
import threading, time, socket, os
from datetime import datetime

# バックエンドスレッドは、ソケットを作成し、リスンし、取得したメッセージを キューに蓄える
# Web リソーススレッドは、ブラウザからの要求に対し、キューから取り出したメッセージを応答する
PATH_TO_SEND='/tmp/pd-local-read.sock'
PATH_TO_RECV='/tmp/pd-local.sock'

BUF_SIZE = 4096
q = Queue()

@hook('after_request')
def enable_cors():
	response.headers['Access-Control-Allow-Origin'] = '*'
	response.headers['Access-Control-Allow-Methods'] = 'PUT, GET, POST, DELETE, OPTIONS'
	response.headers['Access-Control-Allow-Headers'] = 'Origin, Accept, Content-Type, X-Requested-With, X-CSRF-Token'

''' TODO: リクエストの都度、キューから直近のメッセージを取り出します.
	(Pd から pd-gui に送信されるメッセージの読み出しを意図しています)
'''
@route('/')
def get():
	try:
		mess = q.get_nowait()
	except Empty:
		mess = "no data"
		pass
	return "message [%s] <br>rest in queue [%d]<br>" % (mess, q.qsize())


''' TODO: コマンドの中継
	ブラウザからPOSTされた文字列を Pd のソケットに書く
	原則同期はしないので、処理の結果は別のURIを叩いて取得する
	中継したい文字列は　"pd dsp 1" など
'''
@route('/cmd')
def command():
	response.content_type = 'application/json'
	print request.params
	print request.params.keys()
	return {'message': 'OK'}

''' ネットワーク(受信)処理
	ひたすらソケットを読んでキューに追加します.
	Unix ドメインソケットのデータグラムパケットを受信する処理です。
'''
def keep_receive():
	path = PATH_TO_RECV
	if os.path.exists(path):
		os.remove(path)

	fd = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
	fd.bind(path)

	while True:
		data, claddr = fd.recvfrom(BUF_SIZE)
		print 'recved [%d] bytes from [%s]' % (len(data), claddr)
		print data
		recvtime = "[" + datetime.now().strftime("%Y/%m/%d %H:%M:%S") + "]"
		q.put(recvtime + ":" + data)

''' ネットワーク(送信)処理
	Web側の処理からキューイングされたメッセージをネットワークに送信します。
	Unix ドメインソケットのデータグラムパケットを送信します。
'''
def keep_send():
		path = PATH_TO_SEND
		# ソケットつくって、宛先代入して、sendto する
		fd = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)

		try:
			fd.sendto("test", path)
		except socket.error:
			print "Socket error@[sendto]. be sure that the receiver process is up."
			return

		while True:
			fd.sendto("test", path)
			time.sleep(3)

#run(host='localhost', port=8080)

if __name__ == '__main__':
    #threading.Thread(target=run, kwargs=dict(host='localhost', port=8080)).start()
    # keep_receive()
	keep_send()
