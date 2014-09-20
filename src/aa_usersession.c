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

static t_usession *usession_new(t_editor *x){
	
	t_usession *y = (t_usession *)getbytes(sizeof(*y));
	
	y->user_id = new_session_id();
	y->us_canvas = NULL; // LATER
	y->us_editor = x;
	
	return y;
}

// alter session
// TODO: assgin to key event
static void alter_session_1(t_glist *x){
	if (!x->gl_editor){
		x->gl_editor = usession_array_test[0];
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
	
//	t_glist *curr = canvas_getcurrent();
//	alter_session_1(curr);
	
	fprintf(stderr, "[test]alter user session2.\n");
}


