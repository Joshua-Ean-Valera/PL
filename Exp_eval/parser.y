%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_VARS 100

typedef struct {
    char name[64];
    int value;
} Variable;

Variable symbol_table[MAX_VARS];
int var_count = 0;

int get_var_value(const char *name) {
    for (int i = 0; i < var_count; i++)
        if (strcmp(symbol_table[i].name, name) == 0)
            return symbol_table[i].value;
    fprintf(stderr, "Undefined variable: %s\n", name);
    exit(1);
}

void set_var_value(const char *name, int value) {
    for (int i = 0; i < var_count; i++)
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].value = value;
            return;
        }
    strcpy(symbol_table[var_count].name, name);
    symbol_table[var_count++].value = value;
}

extern char id_buf[64];
extern int yylex();
void yyerror(const char *s) { fprintf(stderr, "Error: %s\n", s); }
%}

%union {
    int intval;
    char* strval;
    int condval;
}

%token <intval> INT
%token <strval> ID
%type <intval> expr
%type <condval> cond
%token PRINT IF ELSE WHILE
%token <intval> NUM
%token <intval> OP
%token <intval> RELOP
%type <intval> stmt block program
%type <intval> matched_stmt unmatched_stmt

%start program
%expect 1
%%

program:
    program stmt { $$ = 1; }
  | /* empty */ { $$ = 1; }
  ;

stmt:
    matched_stmt
  | unmatched_stmt
  ;

matched_stmt:
    ID '=' expr ';'       { set_var_value($1, $3); free($1); }
  | PRINT expr ';'        { printf("%d\n", $2); }
  | IF '(' cond ')' matched_stmt ELSE matched_stmt {
        if ($3) $5;
        else $7;
    }
  | WHILE '(' cond ')' matched_stmt {
        while ($3) $5;
    }
  | block
  ;

unmatched_stmt:
    IF '(' cond ')' stmt {
        if ($3) $5;
    }
  | IF '(' cond ')' matched_stmt ELSE unmatched_stmt {
        if ($3) $5;
        else $7;
    }
  ;

block:
    '{' program '}' { $$ = 1; }
  ;


expr:
    NUM                    { $$ = $1; }
  | ID { $$ = get_var_value($1); free($1); }
  | expr OP expr          {
        switch ($2) {
            case '+': $$ = $1 + $3; break;
            case '-': $$ = $1 - $3; break;
            case '*': $$ = $1 * $3; break;
            case '/': $$ = $1 / $3; break;
            case '%': $$ = $1 % $3; break;
        }
    }
  ;

cond:
    expr RELOP expr        {
        switch ($2) {
            case '<': $$ = $1 < $3; break;
            case '>': $$ = $1 > $3; break;
            case '=': $$ = $1 == $3; break;
            case '!': $$ = $1 != $3; break;
            case 'L': $$ = $1 <= $3; break;  // Placeholder for "<="
            case 'G': $$ = $1 >= $3; break;  // Placeholder for ">="
        }
    }
  ;

%%

int main() {
    return yyparse();
}
