%option noyywrap

%{
#include "burczyk_pawlicki.tab.h"
%}

%%
[0-9]+	{printf("[LEX1: %s]\n", yytext); yylval = strdup(yytext);  return(NUM);}
(void)|(char)|(short)|(int)|(long)|(float) {printf("[LEX5: %s]\n", yytext); yylval = strdup(yytext); return(TYPE);}
(struct)|(enum) {printf("[LEX6: %s]\n", yytext); yylval = strdup(yytext); return(TYPE_WITH_ID);}
([a-z]+)|([A-Z]+)   {printf("[LEX2: %s]\n", yytext); yylval = strdup(yytext); return(id);}
[ \t]+  {printf("[LEX3]");}
.|\n    {printf("[LEX4: %s]\n", yytext);  return(*yytext);}
