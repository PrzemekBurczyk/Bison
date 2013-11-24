%option noyywrap
%option yylineno

%{
#include "burczyk_pawlicki.tab.h"
%}

TYPE_E		"void"|"char"|"short"|"int"|"long"|"float"
TYPE_WITH_ID_E	"struct"|"enum"
COMMENT_LINE	"//".*\n
STRING		\"([^\"\n]|\\\n)*\"
BROKEN_STRING	\"([^\"\n]|\\\n)*\n

%x IN_BLOCK COMMENT_BLOCK

%{

extern int yylex(void);
int block_cnt = 0;
char cls_brk_err[128] = "Line %d: closing curly bracket doesn't have a corresponding opening one.";
char broken_str_err[128] = "Line %d: string is not closed in the same line.";
char err_buf[256] = "";
%}

%%

[0-9]+ { printf("[LEX1: %s]\n", yytext); yylval = strdup(yytext);  return(NUM); }
{TYPE_E} { printf("[LEX2: %s]\n", yytext); yylval = strdup(yytext); return(TYPE); }
{TYPE_WITH_ID_E} { printf("[LEX3: %s]\n", yytext); yylval = strdup(yytext); return(TYPE_WITH_ID); }
[a-zA-Z_][a-zA-Z0-9_]* { printf("[LEX4: %s]\n", yytext); yylval = strdup(yytext); return(id); }
<IN_BLOCK>"/*" {
  yymore();
  BEGIN(COMMENT_BLOCK);
  printf("[LEX7a: %s]\n", yytext);
}
<COMMENT_BLOCK>"*/" {
  yymore();
  BEGIN(IN_BLOCK);
  printf("[LEX7b: %s]\n", yytext);
}
<COMMENT_BLOCK>.|\n {
  yymore();
  printf("[LEX7c: %s]\n", yytext);
}
<IN_BLOCK>{COMMENT_LINE} { yymore(); printf("[LEX8: %s]\n", yytext); }
<IN_BLOCK>{BROKEN_STRING} {
  yymore();
  sprintf(err_buf, broken_str_err, yylineno - 1);
  yyerror(err_buf);
}
<IN_BLOCK>{STRING} { yymore(); printf("[LEX9: %s]\n", yytext); }
<IN_BLOCK>"}" {
  if(--block_cnt == 0) {
    yylval = strdup(yytext);
    printf("[LEX5: %s]\n", yytext);
    BEGIN(INITIAL);
    return(body);   
  } else
    yymore();
}
<IN_BLOCK>"{" { yymore(); ++block_cnt; printf("[LEX6: %s]\n", yytext);  }
<IN_BLOCK>.|\n { yymore(); printf("[LEX10: %s]\n", yytext); }
"{" { block_cnt = 1; yymore(); BEGIN(IN_BLOCK); printf("[LEX11: %s]\n", yytext); }
"}" {
  yymore();
  sprintf(err_buf, cls_brk_err, yylineno);
  yyerror(err_buf);
  printf("[LEX12: %s]\n", yytext);
}
[ \t\n]+  /*{printf("[LEX13: ]\n");}*/
. {/*printf("[LEX14: %s]\n", yytext);*/ return(yytext[0]); }


