%option noyywrap
%{
#include<cstdlib>
using namespace std;

//since we are using bison,
//token declarations are now in the 
//following header
#include "example.tab.h"
%}

%%
[ \t]+  ;
[0-9]+  {return NUM;}
.       {return *yytext;}
%%