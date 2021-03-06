%{
#include <stdio.h>
#include <string.h>
#define YYSTYPE char*
#define SIZE 2048
char* return_type;
char* function_name;
char* arguments[16];  //declared arguments
char** arg_ptr;
char* specified_arguments[16];
char** spec_arg_ptr;
char* argument_types[16];
char* full_argument_definitions[16];
char** full_arg_def_ptr;
char* tmp2[16];
char** tmp2_ptr;
char** arg_t_ptr;
char* tmp[16];
char** tmp_ptr;
char* arg_type;
char* body_str;
char* new_style_function;
int first_match = 1;
int i,j;
int old_style = 0;
int new_style = 0;
int param_list_occured = 0;
int declaration_list_occured = 0;
%}

%token NUM body id TYPE TYPE_WITH_ID

%%

functions: function functions { 
                                $$ = malloc(SIZE); 
	                            strcat($$, $1); 
                                strcat($$, " "); 
                                strcat($$, $2); 
                                /* printf("[1 %s]\n", $$); */
                              }
         | function {   
                        $$ = malloc(SIZE); 
	                    strcat($$, $1); 
                        /* printf("[2 %s]\n", $$); */
                    }
         | error functions {yyerrok;}
         ;
function: decl_specifier declarator function_rest { 
                                                    /*
                                                    check_repetitions(arguments);
                                                    check_repetitions(specified_arguments);
                                                    validate_declared_parameters();
                                                    validate_specified_parameters();
                                                    print_arrays();
                                                    */
                                                    $$ = malloc(SIZE); 
	                                                strcat($$, $1); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, $3); 
                                                    //printf("[3 %s]\n", $$);
                                                    if(new_style == 1){
                                                        print_output_original(strdup($$));
                                                    } else {
                                                        print_output();
                                                    }
                                                    initialize_arrays();
                                                  }
        | declarator function_rest { 
                                        /*
                                        check_repetitions(arguments);
                                        check_repetitions(specified_arguments);
                                        validate_declared_parameters();
                                        validate_specified_parameters();
                                        print_arrays();
                                        */
                                        $$ = malloc(SIZE); 
	                                    strcat($$, $1); 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        //printf("[4 %s]\n", $$);
                                        if(new_style == 1){
                                            print_output_original(strdup($$));
                                        } else {
                                            print_output();
                                        }
                                        initialize_arrays();
                                   }
        ;
function_rest: declaration_list body {
                                        declaration_list_occured = 1;
                                        $$ = malloc(SIZE); 
                                        strcat(body_str, $2);
	                                    strcat($$, $1); 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        /* printf("[5 %s]\n", $$); */
                                     }
             | body {
                        $$ = malloc(SIZE); 
                        strcat(body_str, $1);
	                    strcat($$, $1); 
                        /* printf("[6 %s]\n", $$); */
                    }
             ;
decl_specifier: TYPE {
                        if(first_match){
                            *return_type = 0;
                            strcat(return_type, $1);
                        }
                        reset_tmp();
                        reset_tmp2();
                        *arg_type = 0;
                        strcat(arg_type, $1);
                        $$ = malloc(SIZE); 
	                    strcat($$, $1); 
                        /* printf("[7 %s]\n", $$); */
                     }
              | TYPE_WITH_ID id {
                                    if(first_match){
                                        *return_type = 0;
                                        strcat(return_type, $1);
                                        strcat(return_type, " ");
                                        strcat(return_type, $2);
                                    }
                                    reset_tmp();
                                    reset_tmp2();
                                    *arg_type = 0;
                                    strcat(arg_type, $1);
                                    strcat(arg_type, " ");
                                    strcat(arg_type, $2);
                                    $$ = malloc(SIZE); 
	                                strcat($$, $1); 
                                    strcat($$, " "); 
                                    strcat($$, $2); 
                                    /* printf("[8 %s]\n", $$); */
                                }
              ;
declaration_list: declaration declaration_list {
                                                    $$ = malloc(SIZE); 
	                                                strcat($$, $1); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    /* printf("[9 %s]\n", $$); */
                                               }
                | declaration {
                                    $$ = malloc(SIZE); 
	                                strcat($$, $1); 
                                    /* printf("[10 %s]\n", $$); */
                              }
                ;
declaration: decl_specifier declarator_list ';' {
                                                    for(i = 0; *tmp[i] != 0 && i < 16; i++){
                                                        //*spec_arg_ptr = strdup(tmp[i]);
                                                        *spec_arg_ptr = malloc(SIZE);
                                                        strcat(*spec_arg_ptr, tmp[i]);
                                                        spec_arg_ptr++;
                                                    }
                                                    reset_tmp();
                                                    for(i = 0; *tmp2[i] != 0 && i < 16; i++){
                                                        //*full_arg_def_ptr = strdup(tmp2[i]);
                                                        *full_arg_def_ptr = malloc(SIZE);
                                                        strcat(*full_arg_def_ptr, tmp2[i]);
                                                        full_arg_def_ptr++;
                                                    }
                                                    reset_tmp2();
                                                    $$ = malloc(SIZE); 
	                                                strcat($$, $1); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, ";"); 
                                                    /* printf("[11 %s]\n", $$); */
                                                }
           | decl_specifier ';' {
                                    for(i = 0; *tmp[i] != 0 && i < 16; i++){
                                        //*spec_arg_ptr = strdup(tmp[i]);
                                        *spec_arg_ptr = malloc(SIZE);
                                        strcat(*spec_arg_ptr, tmp[i]);
                                        spec_arg_ptr++;
                                    }
                                    reset_tmp();
                                    for(i = 0; *tmp2[i] != 0 && i < 16; i++){
                                        //*full_arg_def_ptr = strdup(tmp2[i]);
                                        *full_arg_def_ptr = malloc(SIZE);
                                        strcat(*full_arg_def_ptr, tmp2[i]);
                                        full_arg_def_ptr++;
                                    }
                                    reset_tmp2();
                                    $$ = malloc(SIZE); 
	                                strcat($$, $1); 
                                    strcat($$, " "); 
                                    strcat($$, ";");  
                                    /* printf("[12 %s]\n", $$); */
                                }
           ;
declarator_list: declarator declarator_rest {
                                                $$ = malloc(SIZE); 
	                                            strcat($$, $1); 
                                                strcat($$, " "); 
                                                strcat($$, $2); 
                                                /* printf("[13 %s]\n", $$); */
                                            }
               | declarator  {
                                $$ = malloc(SIZE); 
	                            strcat($$, $1); 
                                /* printf("[14 %s]\n", $$); */
                             }
               ;
declarator_rest: ',' declarator declarator_rest {
                                                    $$ = malloc(SIZE);
                                                    strcat($$, ","); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, $3); 
                                                    /* printf("[15 %s]\n", $$); */
                                                }
               | ',' declarator {
                                    $$ = malloc(SIZE);
                                    strcat($$, ",");  
                                    strcat($$, " "); 
                                    strcat($$, $2); 
                                    /* printf("[16 %s]\n", $$); */
                                }
               ;
declarator: pointer direct_declarator {
                                            strcat(*tmp2_ptr, "*");
                                            strcat(*tmp2_ptr, $2);
                                            tmp2_ptr++;
                                            $$ = malloc(SIZE); 
	                                        strcat($$, $1); 
                                            strcat($$, " "); 
                                            strcat($$, $2); 
                                            /* printf("[17 %s]\n", $$); */
                                      }
          | direct_declarator {
                                    strcat(*tmp2_ptr, $1);
                                    tmp2_ptr++;
                                    $$ = malloc(SIZE); 
	                                strcat($$, $1); 
                                    /* printf("[18 %s]\n", $$); */
                              }
          ;
direct_declarator: id {
                            if(first_match == 0){
                                //*arg_t_ptr = strdup(arg_type);
                                *arg_t_ptr = malloc(SIZE);
                                strcat(*arg_t_ptr, arg_type);
                                arg_t_ptr++;
                                //*tmp_ptr = strdup($1);
                                *tmp_ptr = malloc(SIZE);
                                strcat(*tmp_ptr, $1);
                                tmp_ptr++;
                            } else {
                                //function_name = strdup($1);
                                function_name = malloc(SIZE);
                                strcat(function_name, $1);
                            }
                            first_match = 0;
                            $$ = malloc(SIZE); 
	                        strcat($$, $1); 
                            /* printf("[19 %s]\n", $$); */
                      }
                  | '(' declarator ')' {
                                            $$ = malloc(SIZE);
                                            strcat($$, "(");
                                            strcat($$, " "); 
                                            strcat($$, $2); 
                                            strcat($$, " "); 
                                            strcat($$, ")"); 
                                            /* printf("[20 %s]\n", $$); */
                                            //function_name = strdup($$);
                                            function_name = malloc(SIZE);
                                            strcat(function_name, $$);
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
                                                        /* printf("[21 %s]\n", $$); */
                                                  }
                  | direct_declarator '[' ']' {
                                                    $$ = malloc(SIZE); 
	                                                strcat($$, $1); 
                                                    strcat($$, " "); 
                                                    strcat($$, "["); 
                                                    strcat($$, " "); 
                                                    strcat($$, "]"); 
                                                    /* printf("[22 %s]\n", $$); */
                                              }
                  | direct_declarator '(' param_list ')' {
                                                            param_list_occured = 1;
                                                            new_style = 1;
                                                            $$ = malloc(SIZE); 
	                                                        strcat($$, $1); 
                                                            strcat($$, " "); 
                                                            strcat($$, "("); 
                                                            strcat($$, " "); 
                                                            strcat($$, $3); 
                                                            strcat($$, " "); 
                                                            strcat($$, ")"); 
                                                            /* printf("[23 %s]\n", $$); */
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
                                                                /* printf("[24 %s]\n", $$); */
                                                              }
                  | direct_declarator '(' ')' {
                                                $$ = malloc(SIZE); 
	                                            strcat($$, $1); 
                                                strcat($$, " "); 
                                                strcat($$, "("); 
                                                strcat($$, " "); 
                                                strcat($$, ")"); 
                                                /* printf("[25 %s]\n", $$); */
                                              }
                  ;
identifier_list: id identifier_rest {
                                        //*arg_ptr = strdup($1);
                                        *arg_ptr = malloc(SIZE);
                                        strcat(*arg_ptr, $1);
                                        arg_ptr++;
                                        $$ = malloc(SIZE); 
	                                    strcat($$, $1); 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        /* printf("[26 %s]\n", $$); */
                                    }
               | id {
                        $$ = malloc(SIZE); 
	                    strcat($$, $1); 
                        //*arg_ptr = strdup($1);
                        *arg_ptr = malloc(SIZE);
                        strcat(*arg_ptr, $1);
                        arg_ptr++;
                        /* printf("[27 %s]\n", $$); */
                    }
               ;
identifier_rest: ',' id identifier_rest {
                                            $$ = malloc(SIZE);
                                            strcat($$, ",");
                                            strcat($$, " "); 
                                            strcat($$, $2); 
                                            strcat($$, " "); 
                                            strcat($$, $3); 
                                            //*arg_ptr = strdup($2);
                                            *arg_ptr = malloc(SIZE);
                                            strcat(*arg_ptr, $2);
                                            arg_ptr++;
                                            /* printf("[28 %s]\n", $$); */
                                        }
               | ',' id  {
                            $$ = malloc(SIZE);
                            strcat($$, ",");
                            strcat($$, " "); 
                            strcat($$, $2); 
                            //*arg_ptr = strdup($2);
                            *arg_ptr = malloc(SIZE);
                            strcat(*arg_ptr, $2);
                            arg_ptr++;
                            /* printf("[29 %s]\n", $$); */
                         }
               ;
param_list: param_declaration param_rest {
                                            $$ = malloc(SIZE); 
	                                        strcat($$, $1); 
                                            strcat($$, " "); 
                                            strcat($$, $2);  
                                            /* printf("[30 %s]\n", $$); */
                                         }
          | param_declaration {
                                $$ = malloc(SIZE); 
	                            strcat($$, $1); 
                                /* printf("[31 %s]\n", $$); */
                              }
          ;
param_rest: ',' param_declaration param_rest {
                                                $$ = malloc(SIZE);
                                                strcat($$, ",");
                                                strcat($$, " "); 
                                                strcat($$, $2); 
                                                strcat($$, " "); 
                                                strcat($$, $3); 
                                                /* printf("[32 %s]\n", $$); */
                                             }
          | ',' param_declaration  {
                                        $$ = malloc(SIZE);
                                        strcat($$, ","); 
                                        strcat($$, " "); 
                                        strcat($$, $2); 
                                        /* printf("[33 %s]\n", $$); */
                                   }
          ;
param_declaration: decl_specifier declarator {
                                                for(i = 0; *tmp[i] != 0 && i < 16; i++){
                                                    //*spec_arg_ptr = strdup(tmp[i]);
                                                    *spec_arg_ptr = malloc(SIZE);
                                                    strcat(*spec_arg_ptr, tmp[i]);
                                                    spec_arg_ptr++;
                                                    //*arg_ptr = strdup(tmp[i]);
                                                    *arg_ptr = malloc(SIZE);
                                                    strcat(*arg_ptr, tmp[i]);
                                                    arg_ptr++;
                                                }
                                                reset_tmp();
                                                for(i = 0; *tmp2[i] != 0 && i < 16; i++){
                                                    //*full_arg_def_ptr = strdup(tmp2[i]);
                                                    *full_arg_def_ptr = malloc(SIZE);
                                                    strcat(*full_arg_def_ptr, tmp2[i]);
                                                    full_arg_def_ptr++;
                                                }
                                                reset_tmp2();
                                                $$ = malloc(SIZE); 
	                                            strcat($$, $1); 
                                                strcat($$, " "); 
                                                strcat($$, $2); 
                                                /* printf("[34 %s]\n", $$); */
                                             }
                  | decl_specifier abstract_declarator {
                                                            //tu też kopiować kod z 34??
                                                            $$ = malloc(SIZE); 
	                                                        strcat($$, $1); 
                                                            strcat($$, " "); 
                                                            strcat($$, $2); 
                                                            /* printf("[35 %s]\n", $$); */
                                                       }
                  | decl_specifier {
                                        $$ = malloc(SIZE); 
	                                    strcat($$, $1); 
                                        /* printf("[36 %s]\n", $$); */
                                   }
                  ;
abstract_declarator: pointer {
                                    $$ = malloc(SIZE); 
	                                strcat($$, $1); 
                                    /* printf("[37 %s]\n", $$); */
                             }
                   | pointer direct_abstract_declarator {
                                                            $$ = malloc(SIZE); 
	                                                        strcat($$, $1); 
                                                            strcat($$, " "); 
                                                            strcat($$, $2); 
                                                            /* printf("[38 %s]\n", $$); */
                                                        }
                   | direct_abstract_declarator {
                                                    $$ = malloc(SIZE); 
	                                                strcat($$, $1); 
                                                    /* printf("[39 %s]\n", $$); */
                                                }
                   ;
direct_abstract_declarator: '(' abstract_declarator ')' {
                                                            $$ = malloc(SIZE);
                                                            strcat($$, "(");
                                                            strcat($$, " "); 
                                                            strcat($$, $2); 
                                                            strcat($$, " "); 
                                                            strcat($$, ")"); 
                                                            /* printf("[40 %s]\n", $$); */
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
                                                                    /* printf("[41 %s]\n", $$); */
                                                                   }
                          | direct_abstract_declarator '[' ']' {
                                                                    $$ = malloc(SIZE); 
	                                                                strcat($$, $1); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "["); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "]"); 
                                                                    /* printf("[42 %s]\n", $$); */
                                                               }
                          | '[' NUM ']' {
                                            $$ = malloc(SIZE);
                                            strcat($$, "["); 
                                            strcat($$, " "); 
                                            strcat($$, $2); 
                                            strcat($$, " "); 
                                            strcat($$, "]"); 
                                            /* printf("[43 %s]\n", $$); */
                                        }
                          | '[' ']' {
                                        $$ = malloc(SIZE);
                                        strcat($$, "["); 
                                        strcat($$, " "); 
                                        strcat($$, "]"); 
                                        /* printf("[44 %s]\n", $$); */
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
                                                                            /* printf("[45 %s]\n", $$); */
                                                                          }
                          | direct_abstract_declarator '(' ')' {
                                                                    $$ = malloc(SIZE); 
	                                                                strcat($$, $1); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, "("); 
                                                                    strcat($$, " "); 
                                                                    strcat($$, ")"); 
                                                                    /* printf("[46 %s]\n", $$); */
                                                               }
                          | '(' param_list ')' {
                                                    $$ = malloc(SIZE);
                                                    strcat($$, "("); 
                                                    strcat($$, " "); 
                                                    strcat($$, $2); 
                                                    strcat($$, " "); 
                                                    strcat($$, ")"); 
                                                    /* printf("[47 %s]\n", $$); */
                                               }
                          | '(' ')' {
                                        $$ = malloc(SIZE);
                                        strcat($$, "("); 
                                        strcat($$, " "); 
                                        strcat($$, ")");  
                                        /* printf("[48 %s]\n", $$); */
                                    }
                          ;
pointer: '*' pointer {
                        $$ = malloc(SIZE);
                        strcat($$, "*"); 
                        strcat($$, " "); 
                        strcat($$, $2); 
                        /* printf("[49 %s]\n", $$); */
                     }
       | '*' {
                $$ = malloc(SIZE);
                strcat($$, "*"); 
                /* printf("[50 %s]\n", $$); */
             }
       ; 
%%

int reset_tmp(){
    for(i = 0; i < 16; i++){
        tmp[i] = malloc(SIZE);
    }
    tmp_ptr = tmp;
}

int reset_tmp2(){
    for(i = 0; i < 16; i++){
        tmp2[i] = malloc(SIZE);
    }
    tmp2_ptr = tmp2;
}

int print_output_original(char* new_style_function){
    // printf("\n*****************\n");
    printf("\n");
    if(validate_arg_list_occurence() == 1 && check_repetitions(arguments) == 1 && check_repetitions(specified_arguments) == 1 && validate_declared_parameters() == 1 && validate_specified_parameters() == 1){
        printf("%s\n", new_style_function);
    }
    // printf("\n*****************\n");
}

int print_output(){
   // printf("\n*****************\n");
    printf("\n");
    if(validate_arg_list_occurence() == 1 && check_repetitions(arguments) == 1 && check_repetitions(specified_arguments) == 1 && validate_declared_parameters() == 1 && validate_specified_parameters() == 1){
        printf("%s %s(", return_type, function_name);
        if(*full_argument_definitions[0] == 0){
            printf("void");
        }
        for(i = 0; i < 16; i++){
            if(*full_argument_definitions[i] != 0){
                if(i == 0){
                    printf("%s %s", argument_types[i], full_argument_definitions[i]);
                } else {
                    printf(", %s %s", argument_types[i], full_argument_definitions[i]);
                }
            }
        }
        printf(")\n");
        printf("%s", body_str);
        printf("\n");
    }
    // printf("\n*****************\n");
}

int validate_arg_list_occurence(){
    int success = 1;
    if(param_list_occured == 1 && declaration_list_occured == 1){
        printf("\nWystapila lista deklaracji przy obecnej liście parametrów\n");
        success = 0;
    }
    return success;
}

int initialize_arrays(){
    reset_tmp();
    reset_tmp2();
    old_style = 0;
    new_style = 0;
    first_match = 1;
    param_list_occured = 0;
    declaration_list_occured = 0;
    body_str = malloc(SIZE * 8);
    new_style_function = malloc(SIZE * 16);
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
