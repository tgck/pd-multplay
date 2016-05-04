Web-Proxy for Pure Data
=======================

Pd-vanilla のための Web-Proxy.

> リスナプロセスを用意して、
> そこから読めるものをブラウザに返す。

> 非同期処理なのでスレッドを分けたい。
> Web API 側と、ソケットリスニング側
> 両者のやり取りは、キューを使う
> http://stackoverflow.com/questions/19604648/threading-a-bottle-app


- TODO : マルチスレッド時のkillを受けたときにきれいに終了する実装