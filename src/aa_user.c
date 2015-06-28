/** file for user session extention **/
#include "aa_user.h"
#include "g_canvas.h"
#include <time.h>
#include <string.h>

// TODO: 精度向上
static long new_session_id() {
	time_t t;
	return time(&t);
}

//
// pd が保持する canvas の数を数える
// 
void glob_list_canvases(t_pd *dummy){
	fprintf(stdout, "[testOut]glob_list_canvases. canvas num[%d].\n", canvas_get_canvas_count());
}

// binbufのログ出力整形用
// 文字列"mae" を文字列"ato"で置換する
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

// editorsに特化したデバッグプリント
void canvas_editors (t_canvas *x){
	if (!x->gl_editors) {
		fprintf(stderr, "[debug]canvas_editors CAN'T dump\n");
		return;
	}
	
	fprintf(stderr, "[debug]canvas_editors START ----------------------------\n");
	
	t_editors *y;
	int i;
	for (y = x->gl_editors, i=0; y; y = y->e_next, i++){
		fprintf(stderr, "  editors[%d][%lx]\n", i, y->e_this);
	}
	
	fprintf(stderr, "[debug]canvas_editors END ------------------------------\n");
	
	
}
