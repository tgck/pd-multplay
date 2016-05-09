# -*- coding: utf-8 -*-
from bottle import route, run, hook, request, response
from Queue import Queue, Empty
import threading, time, socket, os, json
from datetime import datetime

# バックエンドスレッドは、ソケットを作成し、リスンし、取得したメッセージを キューに蓄える
# Web リソーススレッドは、ブラウザからの要求に対し、キューから取り出したメッセージを応答する
PATH_TO_SEND='/tmp/pd-local-read.sock'
PATH_TO_RECV='/tmp/pd-local.sock'

BUF_SIZE = 4096
INTERVAL= 0.5       # check interval of send queue.
recv_q = Queue()	# receiving messages from the app.
send_q = Queue()	# sending messages to the app, registered via web.

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
		mess = recv_q.get_nowait()
	except Empty:
		mess = "no data"
		pass
	return "message [%s] <br>rest in queue [%d]<br>" % (mess, recv_q.qsize())


''' TODO: コマンドの中継
	ブラウザからPOSTされた文字列を Pd のソケットに書く
	原則同期はしないので、処理の結果は別のURIを叩いて取得する
	中継したい文字列は　"pd dsp 1" など
'''
@route('/cmd')
def command():
	# TODO: q キーがあれば
	cmd = request.params.q
	send_q.put(cmd)
	response_ok

def response_ok():
	response.content_type = 'application/json'
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
		data, from_addr = fd.recvfrom(BUF_SIZE)
		print 'recved [%d] bytes from [%s]' % (len(data), from_addr)
		print data
		recvtime = "[" + datetime.now().strftime("%Y/%m/%d %H:%M:%S") + "]"
		recv_q.put(recvtime + ":" + data)	# FIXME 細工はなしにする。いらない

''' ネットワーク(送信)処理
	Web側の処理からキューイングされたメッセージをネットワークに送信します。
	Unix ドメインソケットのデータグラムパケットを送信します。
	前提: 送出先のプロセスが先に起動していること
'''
def keep_send():
		path = PATH_TO_SEND
		# ソケットつくって、宛先代入して、sendto する
		fd = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)

		# 送信先のチェック。
		# 相手がいなければ プログラムは終了する(べき)
		try:
			fd.sendto("pd version 1;", path)
		except socket.error:
			print "Socket error@[sendto]. Be sure that the receiver process is up.\n"

		# 送信先が存在している場合
		while True:
			# キューから読み出す
			try:
				m = send_q.get_nowait()
			except Empty:
				time.sleep(INTERVAL)
				#print "[Proxy:keep_send] No message to send. rest:[%d]\n" % send_q.qsize()
			else:
				#  else 節は try 節で全く例外が送出されなかったときに実行されるコード
				rtn = fd.sendto(m, path)
				#print "[Proxy:keep_send] Sended a message.rtn:[%d] msg:[%s] rest:[%d]\n" % (rtn, m, send_q.qsize())

if __name__ == '__main__':
	# app からの受けの確保
	t1 = threading.Thread(target=keep_receive)
	t1.setDaemon(True)
	t1.start()
	# app への送出の確保
	t2 = threading.Thread(target=keep_send)
	t2.setDaemon(True)
	try:
		t2.start()
	except socket.error:
		pass

	# Web側
	# threading.Thread(target=run, kwargs=dict(host='localhost', port=8080)).start()
	run(host='localhost', port=8080)
