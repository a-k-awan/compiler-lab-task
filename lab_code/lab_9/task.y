%{
#include<cstdio>
#include<iostream>
#include<string>
#include<sstream>

using namespace std;

int yylex(void);
extern FILE* yyin;
void yyerror(const char *);
string Temp();

int var = 0;
%}

/* Type of yylval is now union with a two variables inside 'value' and 'code'. 'value' will serve as the attribute for NUM. This is set in the flex file. code will serve as the attribute for expr. This is a composite of two strings, so that expr has two attributes. Since this is a union, only one of these variables can be used at a time.
*/
%union{
    int value;

    struct _code{
        /* cannot include string (or anything with a constructor)
                directly in a union */
        //address will be the name of a variable
        string* address;
        //code is the three address statements used to compute the associated value, which will be stored in address.
        string* code;
    } code;
}

/* Here we specify that the attribute for NUM has type value (from yylval above) and 
the attribute for expr has type code (which is a struct) */ 
%token <value> NUM
%type <code> expr

%left '+' '-'
%left '*' '/'

%%
exprlist: exprlist expr '\n' {
                            std::cout<<"\n\ngenerated:\n"<< *$2.code <<'\n';
                            delete $2.code;
                            delete $2.address;
                            }   
        |                   /* empty */
        ;

expr: expr '+' expr {
                    string temp = Temp();
                    stringstream c;
                    c<<temp<<'='<<*$1.address<<'+'<<*$3.address<<'\n';
                    string t = c.str();

                    $$.address = new string(temp);
                    $$.code = new string(*$1.code + *$3.code + c.str());

                    delete $1.code;
                    delete $3.code;
                    delete $1.address;
                    delete $3.address;
                    }  
    | expr '*' expr {
                    string temp = Temp();
                    stringstream c;
                    c<<temp<<'='<<*$1.address<<'*'<<*$3.address<<'\n';
                    string t = c.str();

                    $$.address = new string(temp);
                    $$.code = new string(*$1.code + *$3.code + c.str());

                    delete $1.code;
                    delete $3.code;
                    delete $1.address;
                    delete $3.address;
                    }
    | NUM           { 
                    string temp = Temp();
                    stringstream c;
                    c<<temp<<'='<<$1<<'\n';

                    $$.address = new string(temp);
                    $$.code = new string(c.str());
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

