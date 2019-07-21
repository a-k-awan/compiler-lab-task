%option noyywrap
%{
    int chars=0;

%}

%% 
.   {chars++;}
\n  {chars++;}
%%

int main(){
    yylex();
    printf("%d \n",chars);
}
