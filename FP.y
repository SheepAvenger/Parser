%{
#include <stdio.h>
#include "stack.h"
#include "hash.h"
#define DEBUG 1

int isPrime(int p);
void buildST(char* string, char* type);
int yylex();
int yyerror(char*);

struct Hash symbolTable = {NULL, insertToHash, display, setSize, hashkey, findInScope, findInGlobal};
struct Stack activeBlock = {NULL, push, pop, printStack, peek};
struct node* myNode;
int prime, scope = 0;
long long key = 0;

//int yyerror(const char *p) { return -1; }
%}
%union {
    char* strval;
    int intval;
    float fltval;
}
%token <strval> identifier string Boolean
%token <intval> integer
%token <fltval> Float
%token <strval> lBracket
%token <strval>  rBracket lParen rParen equal plus minus mult divide mod equalTo greater less gEqual lEqual notEqual
%token <strval> prog func ret iif then els whle doo and or print 
%right "then" "else"
%%
program: 
    lBracket key_word program_name function_definitions statements rBracket	{printf("\nstart\n");}
     ;

key_word:
	prog		{printf("\nkey_word: %s\n\n\n", $1);}
	| func 		{printf("\nkey_word: %s\n\n\n", $1);}
	| ret		{printf("\nkey_word: %s\n\n\n", $1);}
	| iif 		{printf("\nkey_word: %s\n\n\n", $1);}
	| then		{printf("\nkey_word: %s\n\n\n", $1);}
	| els		{printf("\nkey_word: %s\n\n\n", $1);}
	| whle		{printf("\nkey_word: %s\n\n\n", $1);}
	| doo		{printf("\nkey_word: %s\n\n\n", $1);}
	;
program_name: 
    identifier	{printf("\nprogram-name %s\n\n\n", $1);};

function_definitions: 
    function_definition function_definitions	{printf("\nfunction-definitions\n\n\n");}
    | ;
function_definition:
    lBracket key_word function_name arguments statements ret return_arg rBracket	{printf("\nfunction-definition\n\n\n");}
    ;
function_name: 
    identifier	{printf("\nfunction-name %s\n\n\n", $1);}
    ;
arguments: 
    argument arguments	{printf("\narguments\n\n\n");}
    | ;
argument: 
    identifier	{printf("\nargument %s\n\n\n", $1);}
    ;
return_arg: 
    identifier 	{printf("\nreturn-arg %s\n\n\n", $1);}
    |
    ;
statements: 
    lBracket statement statements	{printf("\nstatements\n\n\n");}
    | ;
statement:
    equal identifier parameters rBracket	{printf("\nassignment_stmt\n\n\n");}
    | lBracket predefined_function parameters rBracket	{printf("\nfunction_call2\n\n\n");}
    | iif expression then statements els statements rBracket	{printf("\nif_stmt\n\n\n");}
    | whle expression doo statements rBracket	{printf("\nwhile_stmt\n\n\n");}
    | lBracket function_name parameters rBracket 	{printf("\nfunction_call1\n\n\n");}
    | string rBracket		{printf("\nstring literal\n\n\n");}
    ;
predefined_function: 
    plus 	{printf("\nplus\n\n\n");}
    | minus 	{printf("\nminus\n\n\n");}
    | mult 	{printf("\nmult\n\n\n");}
    | divide 	{printf("\ndivide\n\n\n");}
    | mod 	{printf("\nmod\n\n\n");}
    | print	{printf("\nprint\n\n\n");}
    ;
parameters: 
    parameter parameters	{printf("\nparameters\n\n\n");}
    | 
    ;
parameter: 
    lBracket function_name parameters rBracket 	{printf("\nparameter1\n\n\n");}
    | identifier 	{printf("\nparameter: %s\n\n\n", $1);}
    | number 		{printf("\nparameter3\n\n\n");}
    | string 		{printf("\nparameter: %s\n\n\n", $1);}
    | Boolean		{printf("\nparameter: %s\n\n\n", $1);}
    | lBracket predefined_function parameters rBracket	{printf("\nparameter6\n\n\n");}
    ;
number: 
    integer 	{printf("\nnumber1: %i\n\n\n", $1);}
    | Float	{printf("\nnumber2: %f\n\n\n", $1);}
    ;

expression: 
    lBracket comparison_operator parameter parameter rBracket 	{printf("\nexpression1\n\n\n");}
    | lBracket Boolean_operator expression expression rBracket	{printf("\nexpression2\n\n\n");}
    | Boolean	{printf("\nexpression3\n\n\n");}
    ;
comparison_operator: 
    equalTo 	{printf("\noperator: %s\n\n\n", $1);}
    | greater 	{printf("\noperator: %s\n\n\n", $1);}
    | less 	{printf("\noperator: %s\n\n\n", $1);}
    | gEqual 	{printf("\noperator: %s\n\n\n", $1);}
    | lEqual 	{printf("\noperator: %s\n\n\n", $1);}
    | notEqual	{printf("\noperator: %s\n\n\n", $1);}
    ;
Boolean_operator: 
    or 	{printf("\noperator: %s\n\n\n", $1);}
    | and	{printf("\noperator: %s\n\n\n", $1);}
    ;
%%
void main()
{
    //extern FILE *yyin;
    FILE *yyin = stdin;
    long int size;
    fseek(yyin, 1, SEEK_END);
	printf("point 1\n");
    size = ftell(yyin);
    rewind(yyin);
    if(size > 271)
    {
        size /= 16;
        prime = size -1;
        for(; ; prime--)
        {
            if(isPrime(prime))
            break;
        }
    }
    else
        prime = 13; // default prime for file size smaller than 272
    if(DEBUG) {printf("Prime: %d\n\n", prime);}    
    
    //symbolTable.head = symbolTable.setSize(symbolTable.head, prime);
    symbolTable.setSize(&symbolTable.head, prime);
    //yylex();
    do {
        int t = yyparse();
	printf("t %i\n", t);
    } while(!feof(yyin));
	fclose(yyin);
   printf("\n========= Finished reading the input file =========\n");
	symbolTable.display(symbolTable.head, prime);  
    printf("\n");    
    activeBlock.printStack(activeBlock.head, "Active Block");
}
void buildST(char* string, char* type)
{    
    if(DEBUG){printf("Read %s, ", string);}      
    if(strcmp(string, "{") == 0)
    {
        //activeBlock.head = activeBlock.push(activeBlock.head, scope);
		 activeBlock.push(&activeBlock.head, scope);
        if(DEBUG)
        {
            printf("Scope %d pushed.\n", scope);
            activeBlock.printStack(activeBlock.head, "Active Block");
            printf("\n");
        }
        scope++;
    }
    else if(strcmp(string, "}") == 0)
    {
        //int scope = activeBlock.peek(activeBlock.head);
        //activeBlock.head = activeBlock.pop(activeBlock.head);
		 int scope = activeBlock.pop(&activeBlock.head);
        if(DEBUG)
        {
            printf("Scope %d popped.\n", scope);
            activeBlock.printStack(activeBlock.head, "Active Block");
            printf("\n");
        }
    }
    else
    {
        key = symbolTable.hashkey(string, prime);
        if(DEBUG){printf("hashkey %lli, ", key);}

        if((myNode = symbolTable.findInScope(symbolTable.head, string, activeBlock.peek(activeBlock.head) , key)) == NULL)
        {
            // not found in current scope
            if(DEBUG){printf("not found in current, ");}
            if((myNode = symbolTable.findInGlobal(symbolTable.head, activeBlock.head, string, key)) == NULL)
            {
                // not found in global scope
                symbolTable.insertToHash(symbolTable.head, string, type, activeBlock.peek(activeBlock.head), key);
                if(DEBUG)
                {
                    printf("not found in global, ");
                    printf("insert to ST.");
                    symbolTable.display(symbolTable.head, prime); 
                    printf("\n");
                }
            }
            else
            {
                // found in global scope
                if(DEBUG){printf("found in global scope %d, won't insert.\n", myNode->scope);}
            }
        }
        else
        {
            // found in current scope
            if(DEBUG){printf("found in current scope %d, won't insert.\n", activeBlock.peek(activeBlock.head));}
        }
    }
}

//check for prime numbers
int isPrime(int p)
{
    int i;
    for(i = 2; p%i != 0; i++);
    if(p==i)
        return 1;
    else
        return 0;
}
int yyerror(char *s)
{
	return -1;
    /* Don't have to do anything! */
}
