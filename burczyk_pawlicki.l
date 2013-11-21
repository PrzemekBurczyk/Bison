%option noyywrap

%{
#include "burczyk_pawlicki.tab.h"
%}

_TYPE "void"|"char"|"short"|"int"|"long"|"float"
_TYPE_WITH_ID "struct"|"enum"
COMMENT_LINE "//".*\n
NOT_ASTERISK [^*]|\n
COMMENT_BLOCK "/*"("*"*{NOT_ASTERISK}|"/")*"*"+"/"

%x IN_BLOCK IN_COMMENT_BLOCK IN_STRING

%{

int block_cnt = 0;
char cls_brk_err[80] = "Closing curly bracket doesn't have a corresponding opening one.";

%}


%%
[0-9]+ { yylval = yytext;  return(NUM); }
[a-zA-Z_][a-zA-Z0-9_]* { yylval = yytext; return(id); }
{_TYPE} { yylval = yytext; return(TYPE);  }
{_TYPE_WITH_ID} { yylval = yytext; return(TYPE_WITH_ID) }
"{" { ++block_cnt; yymore(); BEGIN(IN_BLOCK); }
"}" { yyerror(cls_brk_err); }
<IN_BLOCK>"}" {
  yymore();
  if(--block_cnt == 0) {
    yylval = yytext;
    return(body);
    BEGIN(INITIAL);
  }
}
<IN_BLOCK>"{" { yymore(); ++block_cnt; }
<IN_BLOCK>{COMMENT_BLOCK} { yymore(); }
<IN_BLOCK>{COMMENT_LINE} { yymore(); }
<IN_BLOCK>.|\n { yymore(); }
[ \t]+  /* eat up whitespaces */
.|\n { yyerror("Unrecognised symbol"); }

