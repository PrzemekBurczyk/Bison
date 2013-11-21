%option noyywrap

%{
#include "burczyk_pawlicki.tab.h"
%}

%%
[0-9]+	{printf("[LEX1: %s]\n", yytext); yylval = *yytext;  return(NUM);}
([a-z]+)|([A-Z]+)   {printf("[LEX2: %s]\n", yytext); yylval = *yytext; return(id);}
[ \t]+  {printf("[LEX3]");}
.|\n    {printf("[LEX4: %s]\n", yytext);  return(*yytext);}
