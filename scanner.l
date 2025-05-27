%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h" // Bison header

extern int yylval;
extern char* yytext;
%}

%option noyywrap

%%

[ \t\r\n]+      { /* skip whitespace */ }

"print"         { return PRINT; }
"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
">"             { return GT; }
"<"             { return LT; }
"=="            { return EQ; }
"="             { return ASSIGN; }
";"             { return SEMI; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }

[0-9]+          { yylval = atoi(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval = yytext[0] - 'a'; return VAR; }

.               { printf("Unknown char: %s\n", yytext); }

%%
