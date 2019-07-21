%option noyywrap
%{ 
#include<stdio.h>
int found=0; 
%}

%%
A[a-zA-Z]* {printf("found %s of length %d\n", yytext, yyleng); found++;}
.   {}
\n  {}
%%

int main(int argc, char* argv[]){
    if(argc==2)
        yyin = fopen(argv[1], "r");
    yylex();
    printf("%d \n", found);
}
