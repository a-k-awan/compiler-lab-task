%option noyywrap
%{
#include <iostream>
#include <fstream>
using namespace std;
int found=0; 
%}

%%
^[-+]?[0-9]*\.?[0-9]+$ {cout<<"found :\t"<<yytext<<endl;found++;}
.  {}
\n {}
%%

int main (int argc,char * argv[]){
    if (argc == 2)
        yyin= fopen(argv[1],"r");
    yylex();

}