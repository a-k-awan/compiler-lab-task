%option noyywrap
%{ 
int chars=0;
int words=0;
int lines=0;
%}

%%
[a-zA-Z]+ {chars = chars + yyleng; words++;lines++;}
.   {chars++;lines++;}
\n {chars++;lines++;}
%%

int main(int argc, char* argv[])
{
    if(argc == 2)
        yyin = fopen(argv[1], "r");
    
    yylex();
    printf("chars: %d\n", chars);
    printf("words: %d\n", words);
    printf("lines: %d\n", lines);
    printf("\n");


}