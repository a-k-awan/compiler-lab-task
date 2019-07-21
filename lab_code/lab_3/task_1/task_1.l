%option noyywrap

%{
#include<iostream>
#include<cstdlib>

using namespace std;


const int  T_ID=10;
const int T_NUM= 20;


int lookahead;
int line = 1;

void match(int);
void error();
void stmt();
void expr();
void r();
void term();
void s();
void factor();
%}

%%
[ \t]+ ;
\n  { line++;}
[0-9]+ {return T_NUM; }
[a-zA-Z][0-9a-zA-Z]* {return T_ID;}
.   {return *yytext;}
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

void stmt(){
    switch(lookahead){
    case T_ID:
        match(T_ID); match('='); expr(); match(';');
        break;
    default:
        error();
    }   
}

void expr(){
    term(); r();
}

void r() {
    if(lookahead == '+'){
        match('+'); term(); r();
    } 
}

void term(){
    factor(); s();
}

void s() {
    if(lookahead == '*'){
        match('*'); factor(); s();
    }
}

void factor(){
    switch(lookahead){
    case T_NUM:
        match(T_NUM); 
        break;
    case T_ID:
        match(T_ID); 
        break;
    case '(':
        match('('); expr(); match(')');
        break;
    default:
        error();
    }   
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