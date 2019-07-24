%option noyywrap

%{
#include<iostream>
#include<cstdlib>
using namespace std;
//define token labels

const int  T_IF=210;
const int T_OTHER= 220;
const int T_FOR= 230;
const int T_ID= 250;
const int T_NUM= 260;
const int T_EXPR= 270;
const int T_UNKNOWN= -1;

//define lookahead as a global variable
int lookahead;
int line = 1;

void match(int);
void error();
void optexpr();
void stmt();
void block();
void stmts();

%}

alpha [a-zA-Z_]
alphanum [0-9a-zA-Z_]
digit [0-9]
%%
[ \t]+ ;
\n  { line++;}
if  { return T_IF;}
{alpha}{alphanum}+  { return T_ID;}
{digit}+    {return T_NUM; }
.   { return *yytext;}
%%



int main(int argc, char* argv[])
{
    if(argc == 2)
        yyin = fopen(argv[1], "r");

    lookahead = yylex();
    stmt(); 
    //check trailing input
    if(lookahead)
        error();
}

void program(){
    block();
}

void block(){
    if (lookahead=='{')
        stmts();
    else
        error();
}

void stmts(){
    stmt();
}

void stmtsp(){
    switch(lookahead){
    case T_ID:
    case T_IF:
        stmt(); stmtsp();
        break;
    case '}':
        break;
    default:
        error();
    }
}

void stmt(){
    switch(lookahead){
    case T_ID:
        match(T_ID); match('='); optexpr();
        break;

    case T_IF:
        match(T_IF); match('('); optexpr(); match(')'); stmt(); 
        break;

    default:
        error();

    }   
}

void optexpr() {
    if(lookahead == T_EXPR)
        match(T_EXPR);
}

void match(int terminal)
{
    if(lookahead==terminal)
        lookahead = yylex();
    else
        error();
}

void error(){
    cerr<<"syntax error on line "<<line<<"\n";
    exit(1);
}