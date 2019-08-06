%option noyywrap
%{ 
#include<cstdlib>
#include<string>

using namespace std;

#include "exp2.tab.h"
%}

%%
[ \t]+    ;/*ignore whitespace */
[0-9]+      { 
             yylval.value = atoi(yytext);
             return NUM;
            }
[+\n]       {return *yytext;}
.           {return *yytext;}
%%
