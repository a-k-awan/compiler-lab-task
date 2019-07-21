%option noyywrap
%{
#include <stdio.h>
#define LT 1
#define GT 2
#define OTHER 3
int found =0;
%}

%%
[ \t\n]+ // ignore white space
\>  {return LT;}
\<  {return GT;}
.   {return OTHER;}
%%

int main (int argc,char *argv []){
 if (argc == 2)
    yyin= fopen (argv[1], "r");
 int ret;
 while (ret = yylex()){
     switch(ret){
         case LT:
            printf("<LT>");
            break;
         case GT:
            printf("<GT>");
            break;
         case OTHER:
            printf("<OTHER>");
            break;
     }
 }
    return 0;
 }



