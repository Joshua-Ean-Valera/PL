%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
%}

%option noyywrap

%%

[ \t\r\n]+      ;

"if"            { printf("KEYWORD: if\n"); }
"else"          { printf("KEYWORD: else\n"); }
"while"         { printf("KEYWORD: while\n"); }
"print"         { printf("KEYWORD: print\n"); }
"=="            { printf("OPERATOR: ==\n"); }
"!="            { printf("OPERATOR: !=\n"); }
"<="            { printf("OPERATOR: <=\n"); }
">="            { printf("OPERATOR: >=\n"); }
">"             { printf("OPERATOR: >\n"); }
"<"             { printf("OPERATOR: <\n"); }
"+"             { printf("OPERATOR: +\n"); }
"-"             { printf("OPERATOR: -\n"); }
"*"             { printf("OPERATOR: *\n"); }
"/"             { printf("OPERATOR: /\n"); }
"="             { printf("OPERATOR: =\n"); }
"("             { printf("SYMBOL: (\n"); }
")"             { printf("SYMBOL: )\n"); }
"{"             { printf("SYMBOL: {\n"); }
"}"             { printf("SYMBOL: }\n"); }
";"             { printf("SYMBOL: ;\n"); }
[0-9]+          { printf("NUMBER: %s\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]* { printf("IDENTIFIER: %s\n", yytext); }
.               { printf("UNKNOWN: %s\n", yytext); }

%%

int perform_semantic_analysis(FILE *input) {
    YY_BUFFER_STATE buffer = yy_create_buffer(input, 16384);
    yy_switch_to_buffer(buffer);
    yylex();
    yy_delete_buffer(buffer);
    return 0;
}
