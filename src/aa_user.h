/** file for user session extention **/
#include "m_pd.h"			// struct t_canvas

static void hello(void);
static long new_session_id(void);

// ユーティリティ
// ひとまずここに置いておく. 
int strrep(char *buf, char *mae, char *ato); // binbufのログ出力整形用

//
// editor リスト
//
typedef struct _editors
{	
	t_gobj *e_this;
	struct _editors *e_next; // _symbol とか _namelist に倣ってる
} t_editors;

