%{
#include <stdio.h>
#include <string.h>
#define YYSTYPE char*
#define SIZE 1024
char* return_type;
char* function_name;
char* arguments[16];  //declared arguments
char** arg_ptr;
char* specified_arguments[16];
char** spec_arg_ptr;
char* argument_types[16];
char* full_argument_definitions[16];
char** full_arg_def_ptr;
char** arg_t_ptr;
char* tmp[16];
char** tmp_ptr;
char* arg_type;
int first_match = 1;
int i,j;
int old_style = 0;
int new_style = 0;
%}

%token NUM body id TYPE TYPE_WITH_ID

%%

functions: function functions { 
                                $$ = malloc(SIZE); 
	                            strcat($$, $1); 
                                strcat($$, " "); 
                                strcat($$, $2); 
                                printf("[1 %s]\n", $$);
                              }
         | function {   
                        $$ = malloc(SIZE); 
	                    strcat($$, $1); 
                        printf("[2 %s]\n", $$);
                    }
         ;
function: decl_specifier declarator function_rest { 
                                                    check_repetitions(arguments);
                                                    check_repetitions(specified_arguments);
                                                    validate_declared_parameters();
                                                    validate_specified_parameters();
                                                    print_arrays();
                                                    initialize_arrays();
                                                    $$ = malloc(SIZE); 
	                                                strcat($$, $1); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, $3); 
                                                    printf("[3 %s]\n", $$);
                                                  }
        | declarator function_rest { 
                                        check_repetitions(arguments);
                                        check_repetitions(specified_arguments);
                                        validate_declared_parameters();
                                        validate_specified_parameters();
                                        print_arrays();
                                        initialize_arrays();
                                        $$ = malloc(SIZE); 
	                                    strcat($$, $1); 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        printf("[4 %s]\n", $$);
                                   }
        ;
function_rest: declaration_list body {
                                        $$ = malloc(SIZE); 
	                                    strcat($$, $1); 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        printf("[5 %s]\n", $$);
                                     }
             | body {
                        $$ = malloc(SIZE); 
	                    strcat($$, $1); 
                        printf("[6 %s]\n", $$);
                    }
             ;
decl_specifier: TYPE {
                        if(first_match){
                            *return_type = 0;
                            strcat(return_type, $1);
                        }
                        reset_tmp();
                        *arg_type = 0;
                        strcat(arg_type, $1);
                        $$ = malloc(SIZE); 
	                    strcat($$, $1); 
                        printf("[7 %s]\n", $$);
                     }
              | TYPE_WITH_ID id {
                                    if(first_match){
                                        *return_type = 0;
                                        strcat(return_type, $1);
                                        strcat(return_type, " ");
                                        strcat(return_type, $2);
                                    }
                                    reset_tmp();
                                    *arg_type = 0;
                                    strcat(arg_type, $1);
                                    strcat(arg_type, " ");
                                    strcat(arg_type, $2);
                                    $$ = malloc(SIZE); 
	                                strcat($$, $1); 
                                    strcat($$, " "); 
                                    strcat($$, $2); 
                                    printf("[8 %s]\n", $$);
                                }
              ;
declaration_list: declaration declaration_list {
                                                    $$ = malloc(SIZE); 
	                                                strcat($$, $1); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    printf("[9 %s]\n", $$);
                                               }
                | declaration {
                                    $$ = malloc(SIZE); 
	                                strcat($$, $1); 
                                    printf("[10 %s]\n", $$);
                              }
                ;
declaration: decl_specifier declarator_list ';' {
                                                    for(i = 0; *tmp[i] != 0 && i < 16; i++){
                                                        *spec_arg_ptr = strdup(tmp[i]);
                                                        spec_arg_ptr++;
                                                    }
                                                    reset_tmp();
                                                    $$ = malloc(SIZE); 
	                                                strcat($$, $1); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, ";"); 
                                                    printf("[11 %s]\n", $$);
                                                }
           | decl_specifier ';' {
                                    for(i = 0; *tmp[i] != 0 && i < 16; i++){
                                        *spec_arg_ptr = strdup(tmp[i]);
                                        spec_arg_ptr++;
                                    }
                                    reset_tmp();
                                    $$ = malloc(SIZE); 
	                                strcat($$, $1); 
                                    strcat($$, " "); 
                                    strcat($$, ";");  
                                    printf("[12 %s]\n", $$);
                                }
           ;
declarator_list: declarator declarator_rest {
                                                $$ = malloc(SIZE); 
	                                            strcat($$, $1); 
                                                strcat($$, " "); 
                                                strcat($$, $2); 
                                                printf("[13 %s]\n", $$);
                                            }
               | declarator  {
                                $$ = malloc(SIZE); 
	                            strcat($$, $1); 
                                printf("[14 %s]\n", $$);
                             }
               ;
declarator_rest: ',' declarator declarator_rest {
                                                    $$ = malloc(SIZE);
                                                    strcat($$, ","); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, $3); 
                                                    printf("[15 %s]\n", $$);
                                                }
               | ',' declarator {
                                    $$ = malloc(SIZE);
                                    strcat($$, ",");  
                                    strcat($$, " "); 
                                    strcat($$, $2); 
                                    printf("[16 %s]\n", $$);
                                }
               ;
declarator: pointer direct_declarator {
                                            strcat(*full_arg_def_ptr, "*");
                                            strcat(*full_arg_def_ptr, $2);
                                            full_arg_def_ptr++;
                                            $$ = malloc(SIZE); 
	                                        strcat($$, $1); 
                                            strcat($$, " "); 
                                            strcat($$, $2); 
                                            printf("[17 %s]\n", $$);
                                      }
          | direct_declarator {
                                    strcat(*full_arg_def_ptr, $1);
                                    full_arg_def_ptr++;
                                    $$ = malloc(SIZE); 
	                                strcat($$, $1); 
                                    printf("[18 %s]\n", $$);
                              }
          ;
direct_declarator: id {
                            if(first_match == 0){
                                *arg_t_ptr = strdup(arg_type);
                                arg_t_ptr++;
                                *tmp_ptr = strdup($1);
                                tmp_ptr++;
                            } else {
                                function_name = strdup($1);
                            }
                            first_match = 0;
                            $$ = malloc(SIZE); 
	                        strcat($$, $1); 
                            printf("[19 %s]\n", $$);
                      }
                  | '(' declarator ')' {
                                            $$ = malloc(SIZE);
                                            strcat($$, "(");
                                            strcat($$, " "); 
                                            strcat($$, $2); 
                                            strcat($$, " "); 
                                            strcat($$, ")"); 
                                            printf("[20 %s]\n", $$);
                                            function_name = strdup($$);
                                       }
                  | direct_declarator '[' NUM ']' {
                                                        $$ = malloc(SIZE); 
	                                                    strcat($$, $1); 
                                                        strcat($$, " "); 
                                                        strcat($$, "["); 
                                                        strcat($$, " "); 
                                                        strcat($$, $3); 
                                                        strcat($$, " "); 
                                                        strcat($$, "]"); 
                                                        printf("[21 %s]\n", $$);
                                                  }
                  | direct_declarator '[' ']' {
                                                    $$ = malloc(SIZE); 
	                                                strcat($$, $1); 
                                                    strcat($$, " "); 
                                                    strcat($$, "["); 
                                                    strcat($$, " "); 
                                                    strcat($$, "]"); 
                                                    printf("[22 %s]\n", $$);
                                              }
                  | direct_declarator '(' param_list ')' {
                                                            new_style = 1;
                                                            $$ = malloc(SIZE); 
	                                                        strcat($$, $1); 
                                                            strcat($$, " "); 
                                                            strcat($$, "("); 
                                                            strcat($$, " "); 
                                                            strcat($$, $3); 
                                                            strcat($$, " "); 
                                                            strcat($$, ")"); 
                                                            printf("[23 %s]\n", $$);
                                                         }
                  | direct_declarator '(' identifier_list ')' {
                                                                old_style = 1;
                                                                $$ = malloc(SIZE); 
	                                                            strcat($$, $1); 
                                                                strcat($$, " "); 
                                                                strcat($$, "("); 
                                                                strcat($$, " "); 
                                                                strcat($$, $3); 
                                                                strcat($$, " "); 
                                                                strcat($$, ")"); 
                                                                printf("[24 %s]\n", $$);
                                                              }
                  | direct_declarator '(' ')' {
                                                $$ = malloc(SIZE); 
	                                            strcat($$, $1); 
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
                                        $$ = malloc(SIZE); 
	                                    strcat($$, $1); 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        printf("[26 %s]\n", $$);
                                    }
               | id {
                        $$ = malloc(SIZE); 
	                    strcat($$, $1); 
                        *arg_ptr = strdup($1);
                        arg_ptr++;
                        printf("[27 %s]\n", $$);
                    }
               ;
identifier_rest: ',' id identifier_rest {
                                            $$ = malloc(SIZE);
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
                            $$ = malloc(SIZE);
                            strcat($$, ",");
                            strcat($$, " "); 
                            strcat($$, $2); 
                            *arg_ptr = strdup($2);
                            arg_ptr++;
                            printf("[29 %s]\n", $$);
                         }
               ;
param_list: param_declaration param_rest {
                                            $$ = malloc(SIZE); 
	                                        strcat($$, $1); 
                                            strcat($$, " "); 
                                            strcat($$, $2);  
                                            printf("[30 %s]\n", $$);
                                         }
          | param_declaration {
                                $$ = malloc(SIZE); 
	                            strcat($$, $1); 
                                printf("[31 %s]\n", $$);
                              }
          ;
param_rest: ',' param_declaration param_rest {
                                                $$ = malloc(SIZE);
                                                strcat($$, ",");
                                                strcat($$, " "); 
                                                strcat($$, $2); 
                                                strcat($$, " "); 
                                                strcat($$, $3); 
                                                printf("[32 %s]\n", $$);
                                             }
          | ',' param_declaration  {
                                        $$ = malloc(SIZE);
                                        strcat($$, ","); 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        printf("[33 %s]\n", $$);
                                   }
          ;
param_declaration: decl_specifier declarator {
                                                for(i = 0; *tmp[i] != 0 && i < 16; i++){
                                                    *spec_arg_ptr = strdup(tmp[i]);
                                                    spec_arg_ptr++;
                                                    *arg_ptr = strdup(tmp[i]);
                                                    arg_ptr++;
                                                }
                                                reset_tmp();
                                                $$ = malloc(SIZE); 
	                                            strcat($$, $1); 
                                                strcat($$, " "); 
                                                strcat($$, $2); 
                                                printf("[34 %s]\n", $$);
                                             }
                  | decl_specifier abstract_declarator {
                                                            //tu też kopiować kod z 34??
                                                            $$ = malloc(SIZE); 
	                                                        strcat($$, $1); 
                                                            strcat($$, " "); 
                                                            strcat($$, $2); 
                                                            printf("[35 %s]\n", $$);
                                                       }
                  | decl_specifier {
                                        $$ = malloc(SIZE); 
	                                    strcat($$, $1); 
                                        printf("[36 %s]\n", $$);
                                   }
                  ;
abstract_declarator: pointer {
                                    $$ = malloc(SIZE); 
	                                strcat($$, $1); 
                                    printf("[37 %s]\n", $$);
                             }
                   | pointer direct_abstract_declarator {
                                                            $$ = malloc(SIZE); 
	                                                        strcat($$, $1); 
                                                            strcat($$, " "); 
                                                            strcat($$, $2); 
                                                            printf("[38 %s]\n", $$);
                                                        }
                   | direct_abstract_declarator {
                                                    $$ = malloc(SIZE); 
	                                                strcat($$, $1); 
                                                    printf("[39 %s]\n", $$);
                                                }
                   ;
direct_abstract_declarator: '(' abstract_declarator ')' {
                                                            $$ = malloc(SIZE);
                                                            strcat($$, "(");
                                                            strcat($$, " "); 
                                                            strcat($$, $2); 
                                                            strcat($$, " "); 
                                                            strcat($$, ")"); 
                                                            printf("[40 %s]\n", $$);
                                                        }
                          | direct_abstract_declarator '[' NUM ']' {
                                                                    $$ = malloc(SIZE); 
	                                                                strcat($$, $1); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "["); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, $3); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "]"); 
                                                                    printf("[41 %s]\n", $$);
                                                                   }
                          | direct_abstract_declarator '[' ']' {
                                                                    $$ = malloc(SIZE); 
	                                                                strcat($$, $1); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "["); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "]"); 
                                                                    printf("[42 %s]\n", $$);
                                                               }
                          | '[' NUM ']' {
                                            $$ = malloc(SIZE);
                                            strcat($$, "["); 
                                            strcat($$, " "); 
                                            strcat($$, $2); 
                                            strcat($$, " "); 
                                            strcat($$, "]"); 
                                            printf("[43 %s]\n", $$);
                                        }
                          | '[' ']' {
                                        $$ = malloc(SIZE);
                                        strcat($$, "["); 
                                        strcat($$, " "); 
                                        strcat($$, "]"); 
                                        printf("[44 %s]\n", $$);
                                    }
                          | direct_abstract_declarator '(' param_list ')' {
                                                                            $$ = malloc(SIZE); 
	                                                                        strcat($$, $1); 
                                                                            strcat($$, " "); 
                                                                            strcat($$, "("); 
                                                                            strcat($$, " "); 
                                                                            strcat($$, $3);
                                                                            strcat($$, " "); 
                                                                            strcat($$, ")"); 
                                                                            printf("[45 %s]\n", $$);
                                                                          }
                          | direct_abstract_declarator '(' ')' {
                                                                    $$ = malloc(SIZE); 
	                                                                strcat($$, $1); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "("); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, ")"); 
                                                                    printf("[46 %s]\n", $$);
                                                               }
                          | '(' param_list ')' {
                                                    $$ = malloc(SIZE);
                                                    strcat($$, "("); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, ")"); 
                                                    printf("[47 %s]\n", $$);
                                               }
                          | '(' ')' {
                                        $$ = malloc(SIZE);
                                        strcat($$, "("); 
                                        strcat($$, " "); 
                                        strcat($$, ")");  
                                        printf("[48 %s]\n", $$);
                                    }
                          ;
pointer: '*' pointer {
                        $$ = malloc(SIZE);
                        strcat($$, "*"); 
                        strcat($$, " "); 
                        strcat($$, $2); 
                        printf("[49 %s]\n", $$);
                     }
       | '*' {
                $$ = malloc(SIZE);
                strcat($$, "*"); 
                printf("[50 %s]\n", $$);
             }
       ; 
%%

int reset_tmp(){
    for(i = 0; i < 16; i++){
        tmp[i] = malloc(SIZE);
    }
    tmp_ptr = tmp;
}

int initialize_arrays(){
    old_style = 0;
    new_style = 0;
    first_match = 1;
    full_arg_def_ptr = full_argument_definitions;
    arg_ptr = arguments;
    arg_t_ptr = argument_types;
    spec_arg_ptr = specified_arguments;
    arg_type = malloc(SIZE);
    function_name = malloc(SIZE);
    return_type = malloc(SIZE);
    for(i = 0; i < 16; i++){
        arguments[i] = malloc(SIZE);
        specified_arguments[i] = malloc(SIZE);
        argument_types[i] = malloc(SIZE);
        full_argument_definitions[i] = malloc(SIZE);
    }
}

int validate_declared_parameters(){
    int success = 1;
    int i;
    int j;
    int found;
    for(i = 0; i < 16; i++){
        if(*arguments[i] != 0){
            found = 0;
            for(j = 0; j < 16; j++){
                if(*specified_arguments[j] != 0 && strcmp(arguments[i], specified_arguments[j]) == 0){
                    found = 1;
                }
            }
            if(found == 0){
                printf("Zadeklarowany parametr nie został wyspecyfikowany: %s\n", arguments[i]);
                success = 0;
            }
        }
    }
    return success;
}

int validate_specified_parameters(){
    int success = 1;
    int i;
    int j;
    int found;
    for(i = 0; i < 16; i++){
        if(*specified_arguments[i] != 0){
            found = 0;
            for(j = 0; j < 16; j++){
                if(*arguments[j] != 0 && strcmp(specified_arguments[i], arguments[j]) == 0){
                    found = 1;
                }
            }
            if(found == 0){
                printf("\nWyspecyfikowany parametr nie został zadeklarowany: %s\n", specified_arguments[i]);
                success = 0;
            }
        }
    }
    return success;
}

int print_arrays(){
    if(old_style == 1){
        printf("\nFunkcja w starym stylu\n");
    }
    if(new_style == 1){
        printf("\nFunkcja w nowym stylu\n");
    }
    printf("\nTyp zwracany: %s\n", return_type);
    printf("\nNagłówek/nazwa funkcji: %s\n", function_name);
    printf("\nZadeklarowane parametry funkcji:\n");
    for(i = 0; i < 16; i++){
        if(*arguments[i] != 0){
            printf("%s\n", arguments[i]);
        }
    }
    printf("\nWyspecyfikowane parametry funkcji:\n");
    for(i = 0; i < 16; i++){
        if(*specified_arguments[i] != 0){
            printf("%s\n", specified_arguments[i]);
        }
    }
    printf("\nWyspecyfikowane typy parametrów (kolejność jak w wyspecyfikowanych parametrach):\n");
    for(i = 0; i < 16; i++){
        if(*argument_types[i] != 0){
            printf("%s\n", argument_types[i]);
        }
    }
    printf("\nPełne definicje parametrów:\n");
    for(i = 0; i < 16; i++){
        if(*full_argument_definitions[i] != 0){
            printf("%s\n", full_argument_definitions[i]);
        }
    }
    printf("\n");
}

int check_repetitions(char** arguments){
    int success = 1;
    for(i = 0; i < 16; i++){
        for(j = i + 1; j < 16; j++){
            if(*arguments[i] != 0 && *arguments[j] != 0 && strcmp(arguments[i], arguments[j]) == 0){
                printf("\nNastapilo powtorzenie nazwy parametru funkcji: %s\n", arguments[i]);
                success = 0;
            }
        }
    }
    return success;
}

int main()
{
    initialize_arrays();
    yyparse();
    return 0;
}

int yyerror(char *s){
    printf("Blad: %s\n", s);
}
