%{
#include <iostream>
#include <cstdio>
int yylex(void);
extern FILE* yyin;
void yyerror(const char*);
%}

%union {
    float value;

}

%token <value> NUM
%type <value> term expr

%% 
exprlist : exprlist expr ';' {cout<<$2<<endl;}
         |
         ;

expr : term  {$$ = $1; } 
  | expr '+' term {$$ = $1 + $3; }
  |  expr '-' term {$$ = $1 - $3; }
  | expr '*' term {$$ = $1 * $3; }
  | expr '/' term {$$ = $1 / $3; }
  ;

term: NUM    {$$ = $1;}
    ;
%%

void yyerror(const char* error)
{
    std::cerr<<error<<'\n';
}

int main(int argc, char *argv[]){
    if(argc==2)
        yyin = fopen(argv[1], "r");
    yyparse();
    return 0;
}
