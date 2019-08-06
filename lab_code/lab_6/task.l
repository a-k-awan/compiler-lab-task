%option noyywrap 
%{
#include "task.tab.h"
%}

%%
[ \t]+ ;
[0-9]+(\.[0-9]+)?  { 
            /* yylval is a union */
            yylval.value = atof(yytext);  
             return NUM;
            }
.           {return *yytext;}
%%]