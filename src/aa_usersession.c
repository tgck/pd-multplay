/** file for user session extention **/
#include "aa_usersession.h"
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