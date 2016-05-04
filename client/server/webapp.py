# -*- coding: utf-8 -*- 
from bottle import route, run
from Queue import Queue, Empty
import threading
import time
from datetime import datetime

q = Queue()

@route('/hello')
def hello():
    return "Hello World!"

@route('/')
def get():
	try:
		mess = q.get_nowait()
	except Empty:
		mess = "no data"
		pass
	return ("got from queue: [%s] rest:[%d]" % (mess, q.qsize()))

def method():
	# 5秒に1回キューにメッセージが追加される
	while True:
		time.sleep(5)
		newmess = "recorded at" + datetime.now().strftime("%Y/%m/%d %H:%M:%S")
		q.put(newmess)
		print newmess
	
#run(host='localhost', port=8080)

if __name__ == '__main__':
    threading.Thread(target=run, kwargs=dict(host='localhost', port=8080)).start()
    method()

# リスナプロセスを用意して、
# そこから読めるものをブラウザに返す。

# 非同期処理なのでスレッドを分けたい。
# Web API 側と、ソケットリスニング側
# 両者のやり取りは、キューを使う
# http://stackoverflow.com/questions/19604648/threading-a-bottle-app


# TODO : マルチスレッド時のkillを受けたときにきれいに終了する実装