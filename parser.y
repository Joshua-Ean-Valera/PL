%{
#include <stdio.h>
#include <stdlib.h>

int vars[26];
void yyerror(const char *s);
int yylex(void);

FILE *results_file = NULL;
extern FILE *yyin;

// Forward declaration for semantic analysis
int perform_semantic_analysis(FILE *input);
%}

%token IF ELSE WHILE PRINT
%token VAR NUM
%token PLUS MINUS MUL DIV ASSIGN
%token LPAREN RPAREN SEMI
%token GT LT EQ
%token LBRACE RBRACE

%left PLUS MINUS
%left MUL DIV
%left GT LT EQ

%%

program:
    /* empty */
    | program stmt
    ;

stmt:
      VAR ASSIGN expr SEMI     { vars[$1] = $3; fprintf(stdout, "%c = %d\n", $1 + 'a', $3); if(results_file) fprintf(results_file, "%c = %d\n", $1 + 'a', $3); }
    | PRINT expr SEMI          { fprintf(stdout, "%d\n", $2); if(results_file) fprintf(results_file, "%d\n", $2); }
    | IF LPAREN expr RPAREN block ELSE block
        { if ($3) { ; } else { ; } }
    | IF LPAREN expr RPAREN block
        { if ($3) { ; } }
    | WHILE LPAREN expr RPAREN block
        { while ($3) { ; } }
    | block
    ;

block:
      LBRACE stmts RBRACE
    ;

stmts:
      /* empty */
    | stmts stmt
    ;

expr:
      NUM                      { $$ = $1; }
    | VAR                      { $$ = vars[$1]; }
    | expr PLUS expr           { $$ = $1 + $3; }
    | expr MINUS expr          { $$ = $1 - $3; }
    | expr MUL expr            { $$ = $1 * $3; }
    | expr DIV expr            { $$ = $1 / $3; }
    | expr GT expr             { $$ = $1 > $3; }
    | expr LT expr             { $$ = $1 < $3; }
    | expr EQ expr             { $$ = $1 == $3; }
    | LPAREN expr RPAREN       { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

int main(int argc, char **argv) {
    FILE *input = NULL;
    if (argc > 1) {
        input = fopen(argv[1], "r");
        if (!input) {
            fprintf(stderr, "Could not open input file: %s\n", argv[1]);
            exit(1);
        }
    } else {
        input = stdin;
    }

    // Semantic Analysis
    printf("Semantic Analysis:\n");
    perform_semantic_analysis(input);

    // Reset input file pointer for lexical analysis
    if (input != stdin) {
        fseek(input, 0, SEEK_SET);
    } else {
        printf("\nCannot rewind stdin for lexical analysis.\n");
        fclose(input);
        return 0;
    }

    // Lexical Analysis (parsing and output to results.txt)
    results_file = fopen("results.txt", "w");
    if (!results_file) {
        fprintf(stderr, "Could not open results.txt for writing\n");
        exit(1);
    }
    yyin = input;
    printf("\nLexical Analysis:\n");
    yyparse();
    if (yyin && yyin != stdin) fclose(yyin);
    fclose(results_file);
    return 0;
}

// Semantic analysis: print tokens in the requested format
void perform_semantic_analysis(FILE *input) {
    // Use a minimal Flex scanner for token printing
    extern int semantic_yylex(FILE *input);
    semantic_yylex(input);
}
