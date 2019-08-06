%{
#include<cstdio>
#include<iostream>
#include<string>
#include "ast.h"

using namespace std;

int yylex(void);
extern FILE* yyin;
void yyerror(const char *);
string Temp();

int var = 0;
%}

/* This sets the type of yylval. */

%union{
    int value;
    std::string* id;
    ast::expr* pe;
    ast::stmt* ps;
};

%token T_IF
/* The types of tokens and non-terminals are chosen from the yylval union. */
%token <id> T_ID
%token <value> NUM
%type <pe> expr
%type <ps> A
%type <ps> S
%type <ps> Seq

%left '+' '-'
%left '*' '/'

%%
P : Seq {
        //walk syntax tree to generate code
        $1->gen();
    }

Seq : Seq S { $$ = new ast::seq($1, $2); }
  | %empty {$$ = NULL; }

S : A { $$=$1;}
  | T_IF '(' expr ')' S {
                        $$ = new ast::if_stmt($3, $5);
                    }
  
;

A : T_ID '=' expr ';' {
                    ast::id *t = new ast::id(*$1);
                    ast::expr* p = new ast::assign(t, $3);
                    $$ = new ast::eval(p);
                    }
    ;

expr: expr '+' expr {
                    
                    $$ = new ast::op("+", $1, $3);
                    }  
    | expr '*' expr {
                    $$ = new ast::op("*", $1, $3);
                    
                    }
    | expr '-' expr {
                    $$ = new ast::op("-", $1, $3);
                    
                    }
    | expr '/' expr {
                    $$ = new ast::op("/", $1, $3);
                    
                    }                
    | NUM           { 
                    $$ = new ast::num($1);               
                    }

    |  T_ID          { 
                    $$ = new ast::id(*$1);               
                    }

    ;
%%

//Creates a new temporary variable such as ".L5"
string Temp(){
    stringstream t;
    t<<".L"<<var;
    var++;
    return t.str();
}

void yyerror (const char *error)
{
  std::cout << error << '\n';
}


int main(int argc, char *argv[]){
    if(argc==2)
        yyin = fopen(argv[1], "r");
    yyparse();
    return 0;
}

