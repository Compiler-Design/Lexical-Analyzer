%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define types_of_tokens 11

#define KEYWORD 0
#define ID 1
#define RELOP 2
#define LOGICALOP 3
#define ARITHMOP 4
#define ASSIGNOP 5
#define WHOLE_NUM_CONSTANT 6
#define REAL_CONSTANT 7
#define CHAR_CONSTANT 8
#define STRING_CONSTANT 9
#define PREPROC 10

struct token
{
    int _class;
    char *attributes;
    struct token *next;
};
struct token* symbol_table[types_of_tokens];

int init_map();
const char* getTokenType(int x);
void init_token(struct token* temp, int _cl, char* attr);
struct token* create_token(int _cl, char* attr);
char* duplicate();
int search(struct token* X, int hash_value);
int insert(struct token* A, int hash_value);
void display();
int findTokens();
%}

/* Definitions */

/* Preprocessor Directive */
preproc         #.*$

/* For Comments */
/* Multiline comment will be accepted from a file only */
single_c        \/\/.*$
/* Reference : https://blog.ostermiller.org/finding-comments-in-source-code-using-regular-expressions */
multi_c         \/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/

/* Keywords */
keyword         "auto"|"double"|"int"|"struct"|"break"|"else"|"long"|"switch"|"case"|"enum"|"register"|"typedef"|"char"|"extern"|"return"|"union"|"const"|"float"|"short"|"unsigned"|"continue"|"for"|"signed"|"void"|"default"|"goto"|"sizeof"|"volatile"|"do"|"if"|"static"|"while"
delim_s         [ \t\n]
ws              {delim_s}+
delim           [\"\',;(){}\[\]_]
digit           [0-9]
letter_         [A-Za-z_]
id              {letter_}({letter_}|{digit})*
whole_number    [+-]?{digit}+
real_number     ({whole_number}e{whole_number})|({whole_number}\.(({digit}*e{whole_number})|({digit}+)))

/* For string constants */
escape                  \\([abfnrtv\\'"?0]|(nnn)|(xhh))
non_slash_dquote        [^"\\\n]
char_m                  \"({escape}|{non_slash_dquote})*(\")

/* For character constants */
non_slash_quote         [^'\\]
char_s                  \'({escape}|{non_slash_quote})\'

/* Relational Operators */
relop       [<>]|[<>=!]=
/* Relational Operators */
logicalop   (&{1,2})|(\|{1,2})|!
/* Arithmetic Operators */
arithmop    (\+{1,2})|(-{1,2})|[*/%]
/* Assignment Operators */
assignop    [*/%+-]?=

%%
{preproc}       {struct token* temp=create_token(PREPROC, duplicate()); insert(temp, PREPROC);}
{keyword}       {struct token* temp=create_token(KEYWORD, duplicate()); if(search(temp, KEYWORD)==0){insert(temp, KEYWORD);}}
{id}            {struct token* temp=create_token(ID, duplicate()); if(search(temp, ID)==0){insert(temp, ID);}}
{char_s}        {struct token* temp=create_token(CHAR_CONSTANT, duplicate()); insert(temp, CHAR_CONSTANT);}
{char_m}        {struct token* temp=create_token(STRING_CONSTANT, duplicate()); insert(temp, STRING_CONSTANT);}
{relop}         {struct token* temp=create_token(RELOP, duplicate()); if(search(temp, RELOP)==0){insert(temp, RELOP);}}
{logicalop}     {struct token* temp=create_token(LOGICALOP, duplicate()); if(search(temp, LOGICALOP)==0){insert(temp, LOGICALOP);}}
{arithmop}      {struct token* temp=create_token(ARITHMOP, duplicate()); if(search(temp, ARITHMOP)==0){insert(temp, ARITHMOP);}}
{assignop}      {struct token* temp=create_token(ASSIGNOP, duplicate()); if(search(temp, ASSIGNOP)==0){insert(temp, ASSIGNOP);}}
{whole_number}  {struct token* temp=create_token(WHOLE_NUM_CONSTANT, duplicate()); insert(temp, WHOLE_NUM_CONSTANT);}
{real_number}   {struct token* temp=create_token(REAL_CONSTANT, duplicate()); insert(temp, REAL_CONSTANT);}
{single_c}      {printf("Single-Line Comment : %s\n",yytext);}
{multi_c}       {printf("Multi-Line Comment : %s\n",yytext);}


{delim}|{delim_s}|{ws}      {/* Do Nothing */}
"`done"     {/* Used to terminate the Program if input is taken using Terminal */return 1;}
%%

int yywrap(void)
{
    return 1;
}
int init_map()
{
    for(int i=0;i<types_of_tokens;i++)
        symbol_table[i]=NULL;
    return 0;
}
const char* getTokenType(int x)
{
    if(x==KEYWORD) return "KEYWORDS";
    if(x==ID) return "IDENTIFIERS";
    if(x==RELOP) return "RELATIONAL OPERATORS";
    if(x==LOGICALOP) return "LOGICAL OPERATORS";
    if(x==ARITHMOP) return "ARITHMETIC OPERATORS";
    if(x==ASSIGNOP) return "ASSIGNMENT(& SHORTHAND) OPERATORS";
    if(x==WHOLE_NUM_CONSTANT) return "WHOLE NUMBER CONSTANT";
    if(x==REAL_CONSTANT) return "REAL CONSTANT";
    if(x==CHAR_CONSTANT) return "CHARACTER CONSTANT";
    if(x==STRING_CONSTANT) return "STRING CONSTANT";
    if(x==PREPROC) return "PREPROCESSOR DIRECTIVE";
}
void init_token(struct token* temp, int _cl, char* attr) 
{
    temp->_class=_cl;
    temp->attributes=attr;
}
struct token* create_token(int _cl, char* attr) 
{
    struct token* temp=(struct token*)malloc(sizeof(struct token));
    init_token(temp, _cl, attr);
    return temp;
}
char* duplicate()
{
    if(yyleng>0)
    {
        char* temp=(char*)malloc((yyleng+1)*sizeof(char));
        strcpy(temp, yytext);
        temp[yyleng]='\0';
        return temp;
    }
    return NULL;
}
int search(struct token* X, int hash_value)
{
    int l=strlen(X->attributes);
    if(hash_value<0 || hash_value>=types_of_tokens)
        return -1;

    struct token* temp=symbol_table[hash_value];
    while(temp!=NULL)
    {
        int temp_l=strlen(temp->attributes);
        if(temp_l==l && strcmp(X->attributes, temp->attributes)==0)
            return 1;
        temp=temp->next;
    }
    return 0;
}
int insert(struct token* A, int hash_value)
{
    if(hash_value>=0 && hash_value<types_of_tokens)
    {
        A->next=symbol_table[hash_value];;
        symbol_table[hash_value]=A;
        return 0;
    }
    return -1;
}
void display()
{
    printf("\n--------------------------------------------------------------------");
    printf("\nThe Symbol Table consists of the following Tokens\n\n");
    for(int i=0;i<types_of_tokens;i++)
    {
        printf("%s\n\n", getTokenType(i));
        struct token* temp=symbol_table[i];
        while(temp!=NULL)
        {
        	printf("%d   %s\n",temp->_class,temp->attributes);
            temp=temp->next;    
        }
        printf("\n--------------------------------------------------------------------\n");
    }
}
int findTokens()
{
    init_map();
    printf("\n--------------------------------------------------------------------\n Execution Started.. Tokenizing the Input.. Please Standby\n\n");
    yylex();
    display();
    return 0;
}
int main(int argc, char* argv[])
{
    FILE *fp;
    if(argc>1)
    {
        fp=fopen(argv[1], "r");
        if(fp)
            yyin=fp;
    }
    findTokens();
    if(fp)
        fclose(fp);
    return 0;
}