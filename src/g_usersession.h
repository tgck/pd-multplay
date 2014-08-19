/** file for user session extention **/
#include <time.h>

static void hello() {
	fprintf(stderr, "hello pd.");	
}

// TODO: 精度向上
static long new_session_id() {
	return clock();
}

// add new session to already made editor
//static void editor_add_new_session(){
//}

// user session
typedef struct _usession 
{
	long user_id;
	t_canvas *us_canvas;
	t_editor *us_editor;
} t_usession;

//static t_usession *usession_new(){
static t_usession *usession_new(t_editor *x){
	
	t_usession *y = (t_usession *)getbytes(sizeof(*y));
	
	y->user_id = new_session_id();
	y->us_canvas = NULL;
	y->us_editor = x;
	
	return y;
}
