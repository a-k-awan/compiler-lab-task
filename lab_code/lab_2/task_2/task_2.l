%option noyywrap
%{
#include <iostream>
#include <fstream>
using namespace std;
int found=0; 
%}

%%
[a-zA-z0-9]* {cout<<"found :\t"<<yytext<<endl;found++;}
.  {}
\n {}
%%

int main (){
yyin= fopen("/home/ali/GIKI/compiler construction/lab/lab_code/lab_1/task_1/h.cpp","r");
yylex();

}