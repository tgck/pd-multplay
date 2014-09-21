/** file for user session extention **/
#include <time.h>
#include "m_pd.h"			// struct t_canvas
//#include "g_canvas.h"	// struct t_editor

static void hello(void);
static long new_session_id(void);

// user session
typedef struct _usession 
{
	long user_id;
	t_canvas *us_canvas;
	t_editor *us_editor;
} t_usession;

// session control for temporary debugs
//extern t_usession *usession_array_test[4];
t_usession *usession_array_test[4];
t_usession *usession_new(t_editor *x);

// alter session
static void alter_session_1(void);
static void alter_session_2(void);

// void alter_user_session();	// m_glob.c でプロトタイプ宣言済み