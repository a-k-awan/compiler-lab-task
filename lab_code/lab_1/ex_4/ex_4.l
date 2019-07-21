%option noyywrap
%{
#include <iostream>
using namespace std;
int found= 0;
%}

%%
A[a-zA-z]* {cout<<"found: "<<yytext<<" length "<<yyleng<<'\n'; found++;}
.  {}
\n {}
%%

int main (int argc,char * argv[]){
    if(argc == 2)
        yyin = fopen(argv[1],"r");
    yylex();
    cout<<"found :"<<found<<endl;
}