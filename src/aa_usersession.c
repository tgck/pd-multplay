/** file for user session extention **/
#include "aa_usersession.h"
#include <string.h>

static void hello() {
	fprintf(stderr, "hello pd.");
}

// TODO: 精度向上
static long new_session_id() {
	time_t t;
	time(&t);
	return t;
}

// ユーザID, キャンバスを指定する
// キャンバスに複数のエディタを持たせる
// t_usession *usession_new(int user_id, t_editor *x){
t_usession *usession_new(t_editor *x){
	
	t_usession *y = (t_usession *)getbytes(sizeof(*y));
	
	y->user_id = new_session_id();
	y->us_canvas = NULL; // LATER
	y->us_editor = x;
	
	return y;
}

// alter session
// TODO: assgin to key event
static void alter_session_1(){
} 

static void alter_session_2(){
}

//
// pd が保持する canvas の数を数える
// 
void glob_list_canvases(t_pd *dummy){
	fprintf(stdout, "[testOut]glob_list_canvases.\n");
//	fprintf(stdout, "%s\n", class_getname(dummy));
	fprintf(stdout, "%s\n", class_getname(glob_pdobject)); //-> "pd"
}

void canvas_list_objects(t_glist *x){
	fprintf(stdout, "[testOut]canvas_list_objects.\n");
	
	// ひとまず、キャンバスが持っている
	// オブジェクトの数を数えるユーティリティ
	t_gobj *z;
	int num = 0;
	for (z = x->gl_list; z; z = z->g_next){
		num++;
	}
	fprintf(stdout, "[testOut]number of objects in canvas:%d\n", num);
}

void alter_user_session(t_pd *dummy){
	fprintf(stdout, "[testOut]alter user session1.\n");
	fprintf(stderr, "[testErr]alter user session1.\n");	
	
	// ここで編集対象になっているキャンバスIDを取得しようとしたのだが、
	// そもそもそういう情報は管理されていない。コマンドラインからメッセージを送ろうとするからおかしなことになる。
	// セッションの定義を変更するべし。
	//
	alter_session_1(); // bug
}


// binbufのログ出力整形用
int strrep(char *buf, char *mae, char *ato)
{
	char *mituke;
	size_t maelen, atolen;
	
	maelen = strlen(mae);
	atolen = strlen(ato);
	if (maelen == 0 || (mituke = strstr(buf, mae)) == NULL) return 0;
	memmove(mituke + atolen, mituke + maelen, strlen(buf) - (mituke + maelen - buf ) + 1);
	memcpy(mituke, ato, atolen);
	return 1;
}