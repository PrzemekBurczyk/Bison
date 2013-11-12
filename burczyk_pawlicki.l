%option noyywrap

%{
#include "burczyk.tab.h"
%}

%%
[0-9]+	{yylval = atoi(yytext);  return(NUM);}

([a-z]+)|([A-Z]+)   {yylval = yytext; return(id);}
[ \t]+  /* eat up whitespaces */
.|\n    return(*yytext);
