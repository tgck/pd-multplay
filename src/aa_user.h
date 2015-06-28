/** file for user session extention **/
#include "m_pd.h"			// struct t_canvas

static void hello(void);
static long new_session_id(void);
//void canvas_editors(t_canvas);

// ユーティリティ
// ひとまずここに置いておく. 
int strrep(char *buf, char *mae, char *ato); // binbufのログ出力整形用

//
// editor リスト
//
typedef struct _editors
{	
	t_gobj *e_this;
	struct t_editors *e_next;
} t_editors;

