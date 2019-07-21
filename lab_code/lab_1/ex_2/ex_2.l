%option noyywrap
%{
#include <stdio.h>
int chars=0;
%}

%% 
. {chars ++;}
\n {chars ++;}

%%

int main(int argc,char* argv[]){
    if (argc==2)
        yyin = fopen(argv[1] ,"r");
  yylex();
printf ("%d \n",chars);
}