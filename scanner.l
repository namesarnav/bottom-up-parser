%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int line_num = 1;
int col_num = 1;
%}

%option noinput nounput

%%
[ \t\r]+                { col_num += yyleng; }
\n                      { line_num++; col_num = 1; return '\n'; }

[A-Za-z_][A-Za-z0-9_]*  { yylval.str_val = strdup(yytext); return VARIABLE; }
[0-9]+                  { yylval.int_val = atoi(yytext); return INTEGER; }

"="                     { col_num++; return ASSIGN; }
"+"                     { col_num++; return PLUS; }
"-"                     { col_num++; return MINUS; }
"*"                     { col_num++; return MULT; }
"/"                     { col_num++; return DIV; }
"("                     { col_num++; return LPAREN; }
")"                     { col_num++; return RPAREN; }

.                       {
                          fprintf(stderr, "Lexical error: invalid character '%s' at line %d, col %d\n", yytext, line_num, col_num);
                          exit(1);
                        }
%%

int yywrap(void) { return 1; }