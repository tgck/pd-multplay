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
