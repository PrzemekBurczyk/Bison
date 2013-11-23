%{
#include <stdio.h>
#include <string.h>
#define YYSTYPE char*
char* return_type;
char* function_name;
char* arguments[16];
char** arg_ptr;
char* argument_types[16];
char** arg_t_ptr;
int i;
%}

%token NUM body id TYPE TYPE_WITH_ID

%%

functions: function functions { 
                                $$ = $1; 
                                strcat($$, " "); 
                                strcat($$, $2); 
                                printf("[1 %s]\n", $$);
                              }
         | function { 
                        $$ = $1; 
                        printf("[2 %s]\n", $$);
                    }
         ;
function: decl_specifier declarator function_rest { 
                                                    $$ = $1; 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, $3); 
                                                    printf("[3 %s]\n", $$);
                                                  }
        | declarator function_rest { 
                                        $$ = $1; 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        printf("[4 %s]\n", $$);
                                   }
        ;
function_rest: declaration_list body {
                                        $$ = $1; 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        printf("[5 %s]\n", $$);
                                     }
             | body {
                        $$ = $1; 
                        printf("[6 %s]\n", $$);
                    }
             ;
decl_specifier: TYPE {
                        $$ = $1; 
                        printf("[7 %s]\n", $$);
                     }
              | TYPE_WITH_ID id {
                                    $$ = $1; 
                                    strcat($$, " "); 
                                    strcat($$, $2); 
                                    printf("[8 %s]\n", $$);
                                }
              ;
declaration_list: declaration declaration_list {
                                                    $$ = $1; 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    printf("[9 %s]\n", $$);
                                               }
                | declaration {
                                    $$ = $1; 
                                    printf("[10 %s]\n", $$);
                              }
                ;
declaration: decl_specifier declarator_list ';' {
                                                    $$ = $1; 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, ";"); 
                                                    printf("[11 %s]\n", $$);
                                                }
           | decl_specifier ';' {
                                    $$ = $1; 
                                    strcat($$, " "); 
                                    strcat($$, ";");  
                                    printf("[12 %s]\n", $$);
                                }
           ;
declarator_list: declarator declarator_rest {
                                                $$ = $1; 
                                                strcat($$, " "); 
                                                strcat($$, $2); 
                                                printf("[13 %s]\n", $$);
                                            }
               | declarator  {
                                $$ = $1; 
                                printf("[14 %s]\n", $$);
                             }
               ;
declarator_rest: ',' declarator declarator_rest {
                                                    $$ = malloc(128);
                                                    strcat($$, ","); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, $3); 
                                                    printf("[15 %s]\n", $$);
                                                }
               | ',' declarator {
                                    $$ = malloc(128);
                                    strcat($$, ",");  
                                    strcat($$, " "); 
                                    strcat($$, $2); 
                                    printf("[16 %s]\n", $$);
                                }
               ;
declarator: pointer direct_declarator {
                                            $$ = $1; 
                                            strcat($$, " "); 
                                            strcat($$, $2); 
                                            printf("[17 %s]\n", $$);
                                      }
          | direct_declarator {
                                    $$ = $1; 
                                    printf("[18 %s]\n", $$);
                              }
          ;
direct_declarator: id {
                            $$ = $1; 
                            printf("[19 %s]\n", $$);
                      }
                  | '(' declarator ')' {
                                            $$ = malloc(128);
                                            strcat($$, "(");
                                            strcat($$, " "); 
                                            strcat($$, $2); 
                                            strcat($$, " "); 
                                            strcat($$, ")"); 
                                            printf("[20 %s]\n", $$);
                                       }
                  | direct_declarator '[' NUM ']' {
                                                        $$ = $1; 
                                                        strcat($$, " "); 
                                                        strcat($$, "["); 
                                                        strcat($$, " "); 
                                                        strcat($$, $3); 
                                                        strcat($$, " "); 
                                                        strcat($$, "]"); 
                                                        printf("[21 %s]\n", $$);
                                                  }
                  | direct_declarator '[' ']' {
                                                    $$ = $1; 
                                                    strcat($$, " "); 
                                                    strcat($$, "["); 
                                                    strcat($$, " "); 
                                                    strcat($$, "]"); 
                                                    printf("[22 %s]\n", $$);
                                              }
                  | direct_declarator '(' param_list ')' {
                                                            $$ = $1; 
                                                            strcat($$, " "); 
                                                            strcat($$, "("); 
                                                            strcat($$, " "); 
                                                            strcat($$, $3); 
                                                            strcat($$, " "); 
                                                            strcat($$, ")"); 
                                                            printf("[23 %s]\n", $$);
                                                         }
                  | direct_declarator '(' identifier_list ')' {
                                                                $$ = $1; 
                                                                strcat($$, " "); 
                                                                strcat($$, "("); 
                                                                strcat($$, " "); 
                                                                strcat($$, $3); 
                                                                strcat($$, " "); 
                                                                strcat($$, ")"); 
                                                                printf("[24 %s]\n", $$);
                                                              }
                  | direct_declarator '(' ')' {
                                                $$ = $1; 
                                                strcat($$, " "); 
                                                strcat($$, "("); 
                                                strcat($$, " "); 
                                                strcat($$, ")"); 
                                                printf("[25 %s]\n", $$);
                                              }
                  ;
identifier_list: id identifier_rest {
                                        *arg_ptr = strdup($1);
                                        arg_ptr++;
                                        $$ = $1; 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        printf("[26 %s]\n", $$);
                                    }
               | id {
                        $$ = $1; 
                        *arg_ptr = strdup($1);
                        arg_ptr++;
                        printf("[27 %s]\n", $$);
                    }
               ;
identifier_rest: ',' id identifier_rest {
                                            $$ = malloc(128);
                                            strcat($$, ",");
                                            strcat($$, " "); 
                                            strcat($$, $2); 
                                            strcat($$, " "); 
                                            strcat($$, $3); 
                                            *arg_ptr = strdup($2);
                                            arg_ptr++;
                                            printf("[28 %s]\n", $$);
                                        }
               | ',' id  {
                            $$ = malloc(128);
                            strcat($$, ",");
                            strcat($$, " "); 
                            strcat($$, $2); 
                            *arg_ptr = strdup($2);
                            arg_ptr++;
                            printf("[29 %s]\n", $$);
                         }
               ;
param_list: param_declaration param_rest {
                                            $$ = $1; 
                                            strcat($$, " "); 
                                            strcat($$, $2);  
                                            printf("[30 %s]\n", $$);
                                         }
          | param_declaration {
                                $$ = $1; 
                                printf("[31 %s]\n", $$);
                              }
          ;
param_rest: ',' param_declaration param_rest {
                                                $$ = malloc(128);
                                                strcat($$, ",");
                                                strcat($$, " "); 
                                                strcat($$, $2); 
                                                strcat($$, " "); 
                                                strcat($$, $3); 
                                                printf("[32 %s]\n", $$);
                                             }
          | ',' param_declaration  {
                                        $$ = malloc(128);
                                        strcat($$, ","); 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        printf("[33 %s]\n", $$);
                                   }
          ;
param_declaration: decl_specifier declarator {
                                                $$ = $1; 
                                                strcat($$, " "); 
                                                strcat($$, $2); 
                                                printf("[34 %s]\n", $$);
                                             }
                  | decl_specifier abstract_declarator {
                                                            $$ = $1; 
                                                            strcat($$, " "); 
                                                            strcat($$, $2); 
                                                            printf("[35 %s]\n", $$);
                                                       }
                  | decl_specifier {
                                        $$ = $1; 
                                        printf("[36 %s]\n", $$);
                                   }
                  ;
abstract_declarator: pointer {
                                    $$ = $1; 
                                    printf("[37 %s]\n", $$);
                             }
                   | pointer direct_abstract_declarator {
                                                            $$ = $1; 
                                                            strcat($$, " "); 
                                                            strcat($$, $2); 
                                                            printf("[38 %s]\n", $$);
                                                        }
                   | direct_abstract_declarator {
                                                    $$ = $1; 
                                                    printf("[39 %s]\n", $$);
                                                }
                   ;
direct_abstract_declarator: '(' abstract_declarator ')' {
                                                            $$ = malloc(128);
                                                            strcat($$, "(");
                                                            strcat($$, " "); 
                                                            strcat($$, $2); 
                                                            strcat($$, " "); 
                                                            strcat($$, ")"); 
                                                            printf("[40 %s]\n", $$);
                                                        }
                          | direct_abstract_declarator '[' NUM ']' {
                                                                    $$ = $1; 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "["); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, $3); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "]"); 
                                                                    printf("[41 %s]\n", $$);
                                                                   }
                          | direct_abstract_declarator '[' ']' {
                                                                    $$ = $1; 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "["); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "]"); 
                                                                    printf("[42 %s]\n", $$);
                                                               }
                          | '[' NUM ']' {
                                            $$ = malloc(128);
                                            strcat($$, "["); 
                                            strcat($$, " "); 
                                            strcat($$, $2); 
                                            strcat($$, " "); 
                                            strcat($$, "]"); 
                                            printf("[43 %s]\n", $$);
                                        }
                          | '[' ']' {
                                        $$ = malloc(128);
                                        strcat($$, "["); 
                                        strcat($$, " "); 
                                        strcat($$, "]"); 
                                        printf("[44 %s]\n", $$);
                                    }
                          | direct_abstract_declarator '(' param_list ')' {
                                                                            $$ = $1; 
                                                                            strcat($$, " "); 
                                                                            strcat($$, "("); 
                                                                            strcat($$, " "); 
                                                                            strcat($$, $3);
                                                                            strcat($$, " "); 
                                                                            strcat($$, ")"); 
                                                                            printf("[45 %s]\n", $$);
                                                                          }
                          | direct_abstract_declarator '(' ')' {
                                                                    $$ = $1; 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "("); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, ")"); 
                                                                    printf("[46 %s]\n", $$);
                                                               }
                          | '(' param_list ')' {
                                                    $$ = malloc(128);
                                                    strcat($$, "("); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, ")"); 
                                                    printf("[47 %s]\n", $$);
                                               }
                          | '(' ')' {
                                        $$ = malloc(128);
                                        strcat($$, "("); 
                                        strcat($$, " "); 
                                        strcat($$, ")");  
                                        printf("[48 %s]\n", $$);
                                    }
                          ;
pointer: '*' pointer {
                        $$ = malloc(128);
                        strcat($$, "*"); 
                        strcat($$, " "); 
                        strcat($$, $2); 
                        printf("[49 %s]\n", $$);
                     }
       | '*' {
                $$ = malloc(128);
                strcat($$, "*"); 
                printf("[50 %s]\n", $$);
             }
       ; 
%%

int main()
{
  arg_ptr = arguments;
  arg_t_ptr = argument_types;
  for(i = 0; i < 16; i++){
    arguments[i] = malloc(128);
    argument_types[i] = malloc(128);
  }
  yyparse();
  printf("\n");
  for(i = 0; i < 16; i++){
    printf("%s %s\n", argument_types[i], arguments[i]);
  }
  return 0;
}

int yyerror(char *s){
    printf("Blad: %s\n", s);
}
