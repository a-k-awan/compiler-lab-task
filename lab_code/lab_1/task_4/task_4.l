%option noyywrap
%{
#include <stdio.h>
#define T_LT 1
#define T_GT 2
#define T_OTHER 3
#define T_IF 4
#define T_ID 5
#define T_LPAREN 6
#define T_RPAREN 7    
int found =0;
%}

%%
[ \t\n]+ // ignore white space
\/\/.*$       ;
\/\*(.|\n)*\*\/  {printf("\ncomment %s\n", yytext);}
if      { return  T_IF;}
\>  {return T_LT;}
\<  {return T_GT;}
\(  {return T_LPAREN;}
\)  {return T_RPAREN;}
[a-zA-Z]([0-9]|[a-zA-Z])*    { return T_ID;}
.   {return T_OTHER;}
%%

int main (int argc,char *argv []){
 if (argc == 2)
    yyin= fopen (argv[1], "r");
 int ret;
 while (ret = yylex()){
     switch(ret){
         case T_LT: printf("<LT>"); break;
         case T_GT: printf("<GT>"); break;
         case T_OTHER: printf("<OTHER>"); break;
         case T_IF: printf("<IF>"); break;
         case T_ID:   printf("<ID>"); break;
         case T_LPAREN: printf("<LPAREN>"); break;
         case T_RPAREN: printf("<RPAREN>"); break;
     }
 }
    return 0;
 }



