%option noyywrap

%{
#include<iostream>
#include<cstdlib>

#include "ast.h"
using namespace std;

const int T_IF=310:
const int T_OTHER=320:
const int T_ID=330:
const int T_NUM=360:

int lookahead;
int line =1;
void match (int);
void error ();
ast::stmt* stmts();
ast::stmt* stmt();
ast::stmt* program();
ast::stmt* block();
ast::expr* expr();
ast::expr* factor();
ast::expr* rel();
ast::expr* rp();
%}

alpha [a-zA-Z_]
alphanum [0-9a-zA-Z_]
digit [0-9]
%%
[ \t]+ ;
\n  { line++;}
if  { return T_IF;}
{alpha}{alphanum}*  { return T_ID;}
{digit}+    {return T_NUM; }
.   { return *yytext;}
%%

int main(int argc, char* argv[])
{
    if(argc == 2)
        yyin = fopen(argv[1], "r");

    lookahead = yylex();
    ast::stmt* s=program();
     if(lookahead)
       error();
    s->gen();
}
ast::stmt* program(){
    return block();
}

ast::stmt* block(){
    if (lookahead=='{'){
        ast::stmt* s;
        match('{'); s=stmts(); match('}');      return s;
    }
    else
        error();
    }
    ast::stmt* stmts(){
    switch(lookahead){
    case T_ID:
    case T_IF:
            ast::stmt* l;
                 ast::stmt* r;
        l = stmt(); r= stmts();
            return new ast::seq(l, r);

        break;
    case '{':
            ast::stmt *s;
        s = block();
                return s;
        break;
    default:
        return NULL;
    }
}
ast::stmt* stmt(){
    ast::expr* e;
    ast::stmt *s;

    switch(lookahead){case T_ID:
        e=expr(); match(';');
            return new ast::eval(e);
        break;

    case T_IF:
        match(T_IF); match('('); e=expr(); match(')'); s=stmt();
           return new ast::if_stmt(e, s);
        break;

    case '{':  s=block();
            return s;
    default:
        error();
    }
    }
    ast::expr* expr(){
    ast::expr *left, *right;
    switch(lookahead){
    case T_ID:
    case T_NUM:
     left = rel(); right = rp();
            if(right==NULL){
                         return left;
            }else{
                return new ast::assign(left, right);
            }
                break;

    default:
        error();
    }
} 
ast::expr* rp(){
    switch(lookahead){
    case '=':
            ast::expr* e;
        match('='); e=expr();          return e;
        break;
    case ')':
    case ';':
        return NULL;
              break;

    default:
        error();

    }
}
ast::expr* rel(){
    return factor();
}

ast::expr* factor(){
    int value;
    string name(yytext);
      switch(lookahead){
    case T_ID:
            //store lexeme in string
        match(T_ID);
            //return new tree node
            return new ast::id(name);
        break;
         case T_NUM:
            //store lexeme's integer value
            value = atoi(yytext);
        match(T_NUM);
            return new ast::num(value);
        break;
    default:
        error();
    }
}
void match(int terminal)
{
    if(lookahead==terminal){
        lookahead = yylex();
    }else
        error();
}
void error(){
    cerr<<"syntax error on line "<<line<<"\n";
    exit(1);
}
