/** file for user session extention **/
#include "aa_usersession.h"
#include <string.h>

// TODO: 精度向上
static long new_session_id() {
	time_t t;
	time(&t);
	return t;
}

//
// pd が保持する canvas の数を数える
// 
void glob_list_canvases(t_pd *dummy){
	fprintf(stdout, "[testOut]glob_list_canvases. canvas num[%d].\n", canvas_get_canvas_count());
}

//
// キャンバスが保持するオブジェクトを走査する
//
void canvas_list_objects(t_glist *x){
	t_gobj *z;
	int num = 0;
	for (z = x->gl_list; z; z = z->g_next){
		fprintf(stdout, "-- -- canvas_list_objects[%d]:[%s]\n", 
						num,
						class_getname(pd_class((t_pd*)z)));
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