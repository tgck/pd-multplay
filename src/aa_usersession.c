/** file for user session extention **/
#include "aa_usersession.h"

static void hello() {
	fprintf(stderr, "hello pd.");
}

// TODO: 精度向上
static long new_session_id() {
	time_t t;
	time(&t);
	return t;
}

t_usession *usession_new(t_editor *x){
	
	t_usession *y = (t_usession *)getbytes(sizeof(*y));
	
	y->user_id = new_session_id();
	y->us_canvas = NULL; // LATER
	y->us_editor = x;
	
	return y;
}

// alter session
// TODO: assgin to key event
static void alter_session_1(t_glist *x){
	fprintf(stderr, "alter_session_1\n"); // OK
	if (!x) {
		fprintf(stderr, "x_not_exists");
	} else {
		fprintf(stderr, "x_exists");		
	}
	
	if (!x->gl_editor){
		fprintf(stderr, "alter_session_2");
		// x->gl_editor = usession_array_test[0]; // bug
		
		fprintf(stderr, "changed editor 2->1");
	}
} 

static void alter_session_2(t_glist *x){
	fprintf(stderr, "alter_session_2");
	if (!x->gl_editor){
		x->gl_editor = usession_array_test[1];
		fprintf(stderr, "changed editor 1->2");
	}	
}


void alter_user_session(t_pd *dummy){
	fprintf(stderr, "[test]alter user session1.\n");
	
	// ここで編集対象になっているキャンバスIDを取得しようとしたのだが、
	// そもそもそういう情報は管理されていない。コマンドラインからメッセージを送ろうとするからおかしなことになる。
	// セッションの定義を変更するべし。
	//
	t_canvas *curr = canvas_getcurrent();
	if (curr) {
		fprintf (stderr, "-- curr exists\n");
	} else {
		fprintf (stderr, "-- curr NOT exists\n");
	}
	
	t_glist *curr_g = (t_glist *)curr;
	if (curr_g) {
		fprintf (stderr, "-- (t_glist)curr exists\n");
	} else {
		fprintf (stderr, "-- (t_glist)curr NOT exists\n");
	}
	
	fprintf(stderr, "[test]alter user session1-2.\n");
	
	alter_session_1(curr_g); // bug
	
	fprintf(stderr, "[test]alter user session1-3.\n");	
	fprintf(stderr, "[test]alter user session2.\n");
}


