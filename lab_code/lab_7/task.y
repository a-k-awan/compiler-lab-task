%{
#include <iostream>
int yylex ();
extern FILE* yyin;
%}

%token NUM;
%left '+' '-'
%left '*' '/'

%%
exprlist : exprlist expr '\n' {cout<<"result "<<$2<<endl;}
         |
         ;
expr : expr '+' expr {$$ =$1 + $3;}
     | expr '*' expr {$$ = $1 * $3;}
     | expr '-' expr {$$ = $1 - $3;}
     | expr '/' expr {$$ = $1 / $3;}
     | NUM          {$$ =$1;}
%%

int main (int argc,char*argv[]){
    if (argc==2)
        yyin=fopen (argv[1],"r");
        yyparse();
        return 0;

}