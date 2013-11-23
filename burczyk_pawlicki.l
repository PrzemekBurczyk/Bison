%option noyywrap

%{
#include "burczyk_pawlicki.tab.h"
%}

TYPE_E		"void"|"char"|"short"|"int"|"long"|"float"
TYPE_WITH_ID_E	"struct"|"enum"
COMMENT_LINE	"//".*\n
NOT_ASTERISK	[^*]|\n
COMMENT_BLOCK	"/*"("*"*{NOT_ASTERISK}|"/")*"*"+"/"

%x IN_BLOCK IN_COMMENT_BLOCK IN_STRING

%{

extern int yylex(void);
int block_cnt = 0;
char cls_brk_err[96] = "Closing curly bracket doesn't have a corresponding opening one.";

%}

%%

[0-9]+ {printf("[LEX1: %s]\n", yytext); yylval = strdup(yytext);  return(NUM); }
{TYPE_E} {printf("[LEX2: %s]\n", yytext); yylval = strdup(yytext); return(TYPE); }
{TYPE_WITH_ID_E} {printf("[LEX3: %s]\n", yytext); yylval = strdup(yytext); return(TYPE_WITH_ID); }
[a-zA-Z_][a-zA-Z0-9_]* {printf("[LEX4: %s]\n", yytext); yylval = strdup(yytext); return(id); }
"{" { ++block_cnt; yymore(); BEGIN(IN_BLOCK); }
"}" { yyerror(cls_brk_err); }
<IN_BLOCK>"}" {
  yymore();
  if(--block_cnt == 0) {
    yylval = strdup(yytext);
    return(body);
    BEGIN(INITIAL);
  }
}
<IN_BLOCK>"{" { yymore(); ++block_cnt; }
<IN_BLOCK>{COMMENT_BLOCK} { yymore(); }
<IN_BLOCK>{COMMENT_LINE} { yymore(); }
<IN_BLOCK>.|\n { yymore(); }
[ \t\n]+  {printf("[LEX5: ]\n");}
. {printf("[LEX6: %s]\n", yytext); return(yytext[0]); }

