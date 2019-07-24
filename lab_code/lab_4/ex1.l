%option noyywrap 
%{
#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <string>
#include "symtab.h"

using namespace std;

struct sym_ent;
class sym_tab;
void program ();
void match(int);
void error();
void block () ;
void stmts () ;
void  stmt () ;
void  decls () ;
void  decl () ; 
void  factor () ;
sym_tab* top=NULL;

int lookahead;
int line =1;


//tokens
const int T_TYPE=350;
const int T_ID=351;
%}

letter [A-Za-z]
digit [0-9]
id    {letter}({letter}|{digit})*

%%
[ \t]+    ;/*ignore whitespace */
\n                  { line++; }
int|float|bool|char { return T_TYPE; }
{id}                { return T_ID; }
.                   { return *yytext;}
%%

int main(int argc, char* argv[])
{
    if (argc == 2)
        yyin = fopen(argv[1], "r");


    //read first token
    lookahead = yylex();
    program();

    //check for trailing input
    if(lookahead)
        error();
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

void program(){
        top = NULL;
    block();
}

void block(){
    match('{');

        //save old symbol table. Create new table
        sym_tab* saved = top;
        top = new sym_tab(top);

        cout<<"{\n";

    decls(); 
    stmts();
    match('}');

        //restore previous scope
        delete top;
        top = saved;
        cout<<"}\n";
}

void decls(){
    if(lookahead == T_TYPE){
        decl(); decls();
    }
}

void decl(){
    if(lookahead == T_TYPE){
            //store type lexeme in C++ string 
            string type(yytext);
        match(T_TYPE); 

            //store id lexeme
            string id(yytext);
        match(T_ID); 

        match(';');

            //store symbol in symbol table
            sym_ent *s = new sym_ent;
            s->type = type;

            if(!top->put(id, s)){
                cerr<<"Error: Multiple declarations of "<<id;
            }
    }else{
        error();
    }
}

void stmts(){
    if (lookahead == '{' || lookahead == T_ID){
        stmt(); stmts();
    }
}

void stmt(){
    switch(lookahead){
    case '{':
        block();
        break;

    case T_ID:
        factor(); match(';');
            cout<<";\n";
        break;
    
    default:
        error();

    }
}


void factor(){
    if(lookahead==T_ID){
        string id(yytext);
        match(T_ID);

            sym_ent* s = top->get(id);
            if(!s)
                cerr<<"Undeclared variable "<<id<<'\n';
            else
                cout<<id<<":"<<s->type;
    }else
        error();
}