%option noyywrap
%{
#include <iostream>
#include "task.tab.h"

%}

%%
[ \t]+  ;
[0-9]+  {yylval = atoi(yytext) ; return NUM;}
[+\n]
.       {return *yytext;}
%%