%option noyywrap

%{
#include<iostream>
#include<cstdlib>
#include<string>
#include<sstream>
#include "ast.h"
#include "task.tab.h"

using namespace std;
int line=0;
%}

alpha [a-zA-Z_]
alphanum [0-9a-zA-Z_]
digit [0-9]
%%
[ \t]+ ;
\n  { line++;}
if  { return T_IF;}
{alpha}{alphanum}*  { yylval.id = new string(yytext); return T_ID;}
{digit}+    {
            yylval.value = atoi(yytext); 
            return NUM; }
.   { return *yytext;}
%%