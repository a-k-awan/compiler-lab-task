%{
#include<cstdio>
#include<cstdlib>
#include<iostream>
using namespace std;
//declare lexical analyzer. This will be generated using lex.
int yylex(void);
//input file pointer
extern FILE* yyin;
//This function is called on error
void yyerror(const char *);
%}

/* tokens will be declared in the .y file now */
%token NUM

%%
exprlist: exprlist expr ';'  
            |  /* empty */
            ;

expr: term
      | expr '+' term 
        ;

term: NUM;
%%
void yyerror(const char *error)
{
    std::cerr<<error<<'\n';
}

int main(int argc, char *argv[]){
    if(argc==2)
        yyin = fopen(argv[1], "r");
    //run parser
    yyparse();
    return 0;
}

