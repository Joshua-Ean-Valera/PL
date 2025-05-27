%{
#include <stdio.h>
%}

%%
"class"|"public"|"static"|"void"|"int"|"float"|"return"|"if"|"else"|"while"|"for"   { printf("KEYWORD(%s)\n", yytext); }
[0-9]+                                                                              { printf("NUMBER(%s)\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]*                                                              { printf("IDENTIFIER(%s)\n", yytext); }
"=="|"="|"+"|"-"|"*"|"/"                                                            { printf("OPERATOR(%s)\n", yytext); }
";"                                                                                 { printf("SEMICOLON\n"); }
"("                                                                                 { printf("LPAREN\n"); }
")"                                                                                 { printf("RPAREN\n"); }
"{"                                                                                 { printf("LBRACE\n"); }
"}"                                                                                 { printf("RBRACE\n"); }
[ \t\n]+                                                                            { /* skip whitespace */ }
.                                                                                   { printf("UNKNOWN(%s)\n", yytext); }
%%

int main(void) {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
