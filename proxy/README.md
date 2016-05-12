Web-Proxy for Pure Data
=======================

Pd-vanilla のための Web-Proxy.

> リスナプロセスを用意して、
> そこから読めるものをブラウザに返す。

> 非同期処理なのでスレッドを分けたい。
> Web API 側と、ソケットリスニング側
> 両者のやり取りは、キューを使う
> http://stackoverflow.com/questions/19604648/threading-a-bottle-app



- TBD :
	- サーバからクライアントにどういう形式で返すか？ : JSON?
		- ブラウザでコマンド結果を見る(Consoleがわり、デバッグログ代わりに)
		- 主用途としては、そのまま ローカルの Pd-gui に中継
			- なのでなるだけ加工のないテキスト

	— 起動シーケンス
		- サーバ先
			1. プロキシ
			2. pd
			3. ブラウザ 