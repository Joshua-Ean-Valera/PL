%{
#include <stdio.h>
#include <string.h>
%}

%option noyywrap

%%
"#include"[ \t]*"<"[a-zA-Z0-9_/.]+">"   {printf("%-25s : %s\n", "PREPROCESSOR_DIRECTIVE", yytext); }
"/*"([^*]|\*+[^*/])*\*+"/"     { printf("%-25s : %s\n", "COMMENT", yytext); }
"//".*                          { printf("%-25s : %s\n", "COMMENT", yytext); }
\"([^\"\\]|\\.)*\"             { printf("%-25s : %s\n", "STRING", yytext); }
\'([^\'\\]|\\.)\'              { printf("%-25s : %s\n", "CHAR", yytext); }

[0-9]+\.[0-9]+([eE][+-]?[0-9]+)? { printf("%-25s : %s\n", "FLOAT", yytext); }
[0-9]+([eE][+-]?[0-9]+)         { printf("%-25s : %s\n", "FLOAT", yytext); }
[0-9]+                          { printf("%-25s : %s\n", "INTEGER", yytext); }

"++"|"--"                      { printf("%-25s : %s\n", "UNARY_OP", yytext); }
"=="|"!="|"<="|">="|"<"|">"    { printf("%-25s : %s\n", "REL_OP", yytext); }
"&&"|"||"|"!"                  { printf("%-25s : %s\n", "LOGICAL_OP", yytext); }
"<<"|">>"                     { printf("%-25s : %s\n", "SHIFT_OP", yytext); }
"\+="|"-="|"*="|"/="|"%="     { printf("%-25s : %s\n", "ASSIGN_OP", yytext); }
"&"|"|"|"^"|"~"               { printf("%-25s : %s\n", "BITWISE_OP", yytext); }
"+"|"-"|"*"|"/"|"%"           { printf("%-25s : %s\n", "ARITH_OP", yytext); }
"="                            { printf("%-25s : %s\n", "ASSIGNMENT", yytext); }

"("                             { printf("%-25s : %s\n", "LPAREN", yytext); }
")"                             { printf("%-25s : %s\n", "RPAREN", yytext); }
"{"                             { printf("%-25s : %s\n", "LBRACE", yytext); }
"}"                             { printf("%-25s : %s\n", "RBRACE", yytext); }
"["                             { printf("%-25s : %s\n", "LBRACKET", yytext); }
"]"                             { printf("%-25s : %s\n", "RBRACKET", yytext); }
";"                             { printf("%-25s : %s\n", "SEMICOLON", yytext); }
","                             { printf("%-25s : %s\n", "COMMA", yytext); }
"."                             { printf("%-25s : %s\n", "DOT", yytext); }
":"                             { printf("%-25s : %s\n", "COLON", yytext); }
"\?"                            { printf("%-25s : %s\n", "QUESTION", yytext); }

[a-zA-Z_][a-zA-Z0-9_]*          {
    if (strcmp(yytext, "int") == 0 || strcmp(yytext, "return") == 0 || strcmp(yytext, "if") == 0)
        printf("%-25s : %s\n", "KEYWORD", yytext);
    else
        printf("%-25s : %s\n", "IDENTIFIER", yytext);
}

[ \t\n]+  ;
%%

int main() {
    yylex();
    return 0;
}
