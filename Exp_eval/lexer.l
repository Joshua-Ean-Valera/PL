%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern char id_buf[64];
%}

%option noyywrap

%%
[ \t]+                  ;
\n                      ;
"print"                 { return PRINT; }
"if"                    { return IF; }
"else"                  { return ELSE; }
"while"                 { return WHILE; }

[0-9]+                  { yylval.intval = atoi(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.strval = strdup(yytext); return ID; }

"=="   { yylval.intval = '='; return RELOP; }
"!="   { yylval.intval = '!'; return RELOP; }
"<="   { yylval.intval = 'L'; return RELOP; }
">="   { yylval.intval = 'G'; return RELOP; }
"<"    { yylval.intval = '<'; return RELOP; }
">"    { yylval.intval = '>'; return RELOP; }
"="                     { return '='; }
";"                     { return ';'; }
"("                     { return '('; }
")"                     { return ')'; }
"{"                     { return '{'; }
"}"                     { return '}'; }
"+"    { yylval.intval = '+'; return OP; }
"-"    { yylval.intval = '-'; return OP; }
"*"    { yylval.intval = '*'; return OP; }
"/"    { yylval.intval = '/'; return OP; }
"%"    { yylval.intval = '%'; return OP; }
.                       ;
%%

