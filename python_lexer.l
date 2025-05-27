%{
#include <stdio.h>
%}

%%
"def"|"return"|"if"|"else"|"elif"|"while"|"for"|"in"|"import"   { printf("KEYWORD(%s)\n", yytext); }
[0-9]+                                                          { printf("NUMBER(%s)\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]*                                          { printf("IDENTIFIER(%s)\n", yytext); }
"=="|"="|"+"|"-"|"*"|"/"                                        { printf("OPERATOR(%s)\n", yytext); }
":"                                                             { printf("COLON\n"); }
"("                                                             { printf("LPAREN\n"); }
")"                                                             { printf("RPAREN\n"); }
[ \t\n]+                                                        { /* skip whitespace */ }
.                                                               { printf("UNKNOWN(%s)\n", yytext); }
%%

int main(void) {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
