%{
#include <stdio.h>
#include <string.h>
#define YYSTYPE char*
%}

%token NUM body id TYPE TYPE_WITH_ID

/*%union {
int _int;
char* _pchar;
}*/

/*%token <_int> NUM 
       <_pchar> body id TYPE TYPE_WITH_ID*/

/*%type <_pchar> functions function function_rest decl_specifier declaration_list declaration declarator_list declarator_rest declarator direct_declarator identifier_list identifier_rest param_list param_rest param_declaration abstract_declarator direct_abstract_declarator pointer*/

%%

/*int - specyfikator typu fun(a, b, c - lista identyfikatorów) - deklarator
    int a      -|
    double b,c -|- lista deklaracji*/
    
/*int fun(int a, int b - lista parametrów)*/

functions: function functions {printf("[1 %s %s]\n", $1, $2);}
         | function {printf("2\n");}
         ;
function: decl_specifier declarator function_rest {printf("3\n");}
        | declarator function_rest {printf("4\n");}
        ;
function_rest: declaration_list body {printf("5\n");}
             | body {printf("6\n");}
             ;
decl_specifier: TYPE {printf("[7 %s]\n", $1);}
              | TYPE_WITH_ID id {printf("8\n");}
              ;
declaration_list: declaration declaration_list {printf("9\n");}
                | declaration {printf("10\n");}
                ;
declaration: decl_specifier declarator_list ';' {printf("11\n");}
           | decl_specifier ';' {printf("12\n");}
           ;
declarator_list: declarator declarator_rest {printf("13\n");}
               | declarator  {printf("14\n");}
               ;
declarator_rest: ',' declarator declarator_rest {printf("15\n");}
               | ',' declarator {printf("16\n");}
               ;
declarator: pointer direct_declarator {printf("17\n");}
          | direct_declarator {printf("[18 %s]\n", $1);}
          ;
direct_declarator: id {printf("[19 %s]\n", $1);}
                  | '(' declarator ')' {printf("20\n"); $$ = $2;}
                  | direct_declarator '[' NUM ']' {printf("21\n");}
                  | direct_declarator '[' ']' {printf("22\n");}
                  | direct_declarator '(' param_list ')' {printf("23\n");}
                  | direct_declarator '(' identifier_list ')' {printf("[24 %s ]\n", $1, $3);}
                  | direct_declarator '(' ')' {printf("25\n");}
                  ;
identifier_list: id identifier_rest {printf("[26 %s %s]\n", $1, $2);}
               | id {printf("27\n");}
               ;
identifier_rest: ',' id identifier_rest {printf("[28 %s %s]\n", $2, $3); $$ = $2; strcat($$, ","); strcat($$, $3);}
               | ',' id  {printf("[29 %s %s]\n", $1, $2); strcat($$, ","); strcat($$, $2); printf("#%s\n", $$);}
               ;
param_list: param_declaration param_rest {printf("30\n");}
          | param_declaration {printf("31\n");}
          ;
param_rest: ',' param_declaration param_rest {printf("32\n");}
          | ',' param_declaration  {printf("33\n");}
          ;
param_declaration: decl_specifier declarator {printf("34\n");}
                  | decl_specifier abstract_declarator {printf("35\n");}
                  | decl_specifier {printf("36\n");}
                  ;
abstract_declarator: pointer {printf("37\n");}
                   | pointer direct_abstract_declarator {printf("38\n");}
                   | direct_abstract_declarator {printf("39\n");}
                   ;
direct_abstract_declarator: '(' abstract_declarator ')' {printf("40\n");}
                          | direct_abstract_declarator '[' NUM ']' {printf("41\n");}
                          | direct_abstract_declarator '[' ']' {printf("42\n");}
                          | '[' NUM ']' {printf("43\n");}
                          | '[' ']' {printf("44\n");}
                          | direct_abstract_declarator '(' param_list ')' {printf("45\n");}
                          | direct_abstract_declarator '(' ')' {printf("46\n");}
                          | '(' param_list ')' {printf("47\n");}
                          | '(' ')' {printf("48\n");}
                          ;
pointer: '*' pointer {printf("49\n");}
       | '*' {printf("50\n");}
       ; 
%%

int main()
{
  yyparse();
  return 0;
}

int yyerror(char *s){
    printf("Blad: %s\n", s);
}
