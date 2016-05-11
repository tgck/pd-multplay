pd-multplay
===========

pd-multiplay
  based on 0.45.4 vanilla


#### 依存性

- portaudio
- portmidi

```
mkdir obj
mkdir extra

```


#### UC

* ブラウザから送る各種のメッセージ
	- フロントのパッチの全容をリクエストする
		結果は自分のみに届けば良い
		- Not Pub-Sub.
	- パッチの加工
		- 結果はみんなに届いてほしい
		- Is a Pub-Sub

* ブラウザで読めるデバッグログ
	- 

* 複数人数でブラウザを叩いた時の一貫性は？
	- Pub-sub的な何か
	