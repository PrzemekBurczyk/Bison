%option noyywrap

%{
#include "burczyk_pawlicki.tab.h"
%}

%%
[0-9]+	{printf("LEX1: %s\n", yytext); yylval = *yytext;  return(NUM);}

([a-z]+)|([A-Z]+)   {printf("LEX2: %s\n", yytext); yylval = *yytext; return(id);}
[ \t]+  /* eat up whitespaces */
.|\n    {printf("LEX3: %s\n", yytext);  return(*yytext);}
