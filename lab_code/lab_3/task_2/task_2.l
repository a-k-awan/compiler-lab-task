%option noyywrap
%{
#include <iostream>
#include <cstdlib>
using namespace std;    
// intializing tokens
const int T_IF=10;
const int T_ID=20;
const int T_NUM=30;
const int T_OTHER=40;
const int T_FOR=50;

int lookahead;
int line = 1;

// functions prototype
void match(int);
void error();
void optexpr();
void stmt ();
void expr();
void term();
void factor();
void r();
void s();   
%}

%%
[ \t]+ ;    // for white spaces
\n  { line++;}
if  { return T_IF;}
for { return T_FOR;}
other   { return T_OTHER;}
[0-9]+ {return T_NUM; }
[a-zA-Z][0-9a-zA-Z]* {return T_ID;}
.   { return *yytext;}
%%

int main(int argc,char * argv[]){

if (argc ==2)
yyin = fopen(argv[1], "r");

    lookahead = yylex();
    stmt(); 
if(lookahead)
error();

}

void stmt(){
    switch(lookahead){
    case T_ID:
        match(T_ID);match('='); expr(); match(';');
        break;

    case T_OTHER: 
        match(T_OTHER);
        break;

    case T_IF:
        match(T_IF); match('('); expr(); match(')'); stmt(); 
        break;

    case T_FOR:
        match(T_FOR); match('('); optexpr(); match(';');
        optexpr(); match(';'); optexpr(); match(')'); stmt();
        break;
    
    default:
        error();

    }   

}

void expr(){
    term(); r();
}

void optexpr() { expr();}
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
