/** file for user session extention **/
#include "aa_usersession.h"
#include <string.h>

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

//
// pd が保持する canvas の数を数える
// 
void glob_list_canvases(t_pd *dummy){
	fprintf(stdout, "[testOut]glob_list_canvases. canvas num[%d].\n", canvas_get_canvas_count());
//	fprintf(stdout, "%s\n", class_getname(glob_pdobject)); //-> "pd"
}

//
// キャンバスが保持するオブジェクトを走査する
//
void canvas_list_objects(t_glist *x){
	fprintf(stdout, "[testOut]canvas_list_objects.\n");
	
	t_gobj *z;
	int num = 0;
	for (z = x->gl_list; z; z = z->g_next){

		fprintf(stdout, "-- -- object dump[%s]\n", class_getname(pd_class((t_pd*)z)));
		// OK:  z を t_pd* にキャストしてからclass化して名前をとる
//		fprintf(stdout, "-- -- %s", glist_getcanvas(z)->gl_name->s_name);
//		fprintf(stdout, "-- -- [.x%lx][%s]\n", ((t_glist*)z)->gl_name,
//						((t_glist*)z)->gl_name->s_name);
		num++;
	}
	fprintf(stdout, "[testOut]number of objects in canvas[%d]\n", num);
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