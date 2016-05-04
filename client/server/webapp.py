# -*- coding: utf-8 -*- 
from bottle import route, run
from Queue import Queue, Empty
import threading
import time
from datetime import datetime

button_pressed = Queue()

@route('/')
def hello():
    return "Hello World!"

def method():
	while True:
		print "hoge " + datetime.now().strftime("%Y/%m/%d %H:%M:%S")
		time.sleep(3)
		# try:
		# 	button_pressed.get_nowait()
		# except Empty:
		# 	pass
		# else:
  #           print "push recieved"


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


# TODO : マルチスレッド時のプロセス終了