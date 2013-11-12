%{
#include <stdio.h>
%}

%union {
int _int;
char* _pchar;
}

%token <_int> NUM 
       <_pchar> body id TYPE TYPE_WITH_ID

%type <_pchar> functions function function_rest decl_specifier declaration_list declaration declarator_list declarator_rest declarator direct_declarator identifier_list identifier_rest param_list param_rest param_declaration abstract_declarator direct_abstract_declarator pointer

%%

/*int - specyfikator typu fun(a, b, c - lista identyfikatorów) - deklarator
    int a      -|
    double b,c -|- lista deklaracji*/
    
/*int fun(int a, int b - lista parametrów)*/

functions: function functions
         | function
         ;
function: decl_specifier declarator function_rest
        | declarator function_rest
        ;
function_rest: declaration_list body
             | body
             ;
decl_specifier: TYPE
              | TYPE_WITH_ID id
              ;
declaration_list: declaration declaration_list
                | declaration
                ;
declaration: decl_specifier declarator_list ';'
           | decl_specifier ';'
           ;
declarator_list: declarator declarator_rest
               | declarator 
               ;
declarator_rest: ',' declarator declarator_rest
               | ',' declarator
               ;
declarator: pointer direct_declarator
          | direct_declarator
          ;
direct_declarator: id
                  | '(' declarator ')'
                  | direct_declarator '[' NUM ']'
                  | direct_declarator '[' ']'
                  | direct_declarator '(' param_list ')'
                  | direct_declarator '(' identifier_list ')'
                  | direct_declarator '(' ')'
                  ;
identifier_list: id identifier_rest
               | id
               ;
identifier_rest: ',' id identifier_rest
               | ',' id 
               ;
param_list: param_declaration param_rest
          | param_declaration
          ;
param_rest: ',' param_declaration param_rest
          | ',' param_declaration 
          ;
param_declaration: decl_specifier declarator
                  | decl_specifier abstract_declarator
                  | decl_specifier
                  ;
abstract_declarator: pointer
                   | pointer direct_abstract_declarator
                   | direct_abstract_declarator
                   ;
direct_abstract_declarator: '(' abstract_declarator ')'
                          | direct_abstract_declarator '[' NUM ']'
                          | direct_abstract_declarator '[' ']'
                          | '[' NUM ']'
                          | '[' ']'
                          | direct_abstract_declarator '(' param_list ')'
                          | direct_abstract_declarator '(' ')'
                          | '(' param_list ')'
                          | '(' ')'
                          ;
pointer: '*' pointer
       | '*'
       ; 
%%

int yyerror(char *s) {
  printf("blad: %s\n", s);
}

int main()
{
  yyparse();
  return 0;
}
