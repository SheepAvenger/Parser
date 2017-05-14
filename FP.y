%{
#include <stdio.h>
//#include "scanner.l"
#include "bTree.h"
#define DEBUG 1

//int isPrime(int p);
int yylex();
int yyerror(char*);
//int myPrime;

//int yyerror(const char *p) { return -1; }
%}
%union {
    char* strval;
    int intval;
    float fltval;
}
%token <strval> identifier cString Boolean
%token <intval> integer
%token <fltval> Float
%token <strval> lBracket
%token <strval> rBracket lParen rParen equal plus minus mult divide mod equalTo greater less gEqual lEqual notEqual
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
    function_definitions function_definition    {printf("\nfunction-definitions\n\n\n");}
    | ;
function_definition:
    lBracket key_word function_name arguments statements ret return_arg rBracket	{printf("\nfunction-definition\n\n\n");}
    ;
function_name: 
    identifier	{printf("\nfunction-name %s\n\n\n", $1);}
    ;
arguments: 
    arguments argument  {printf("\narguments\n\n\n");}
    | ;
argument: 
    identifier	{printf("\nargument %s\n\n\n", $1);}
    ;
return_arg: 
    identifier 	{printf("\nreturn-arg %s\n\n\n", $1);}
    |
    ;
statements: 
    statements statement   {printf("\nstatements\n\n\n");}
    | statement	            {printf("\nstatement\n\n\n");}
    ;
statement:
    lBracket equal identifier parameters rBracket	{printf("\nassignment_stmt\n\n\n");}
    | lBracket predefined_function parameters rBracket	{printf("\nfunction_call2\n\n\n");}
    | lBracket iif expression then statements els statements rBracket	{printf("\nif_stmt\n\n\n");}
    | lBracket whle expression doo statements rBracket	{printf("\nwhile_stmt\n\n\n");}
    | lBracket function_name parameters rBracket 	{printf("\nfunction_call1\n\n\n");}
    ;
predefined_function: 
    plus 	    {printf("\nplus\n\n\n");}
    | minus 	{printf("\nminus\n\n\n");}
    | mult 	    {printf("\nmult\n\n\n");}
    | divide 	{printf("\ndivide\n\n\n");}
    | mod 	    {printf("\nmod\n\n\n");}
    | print	    {printf("\nprint\n\n\n");}
    ;
parameters: 
    parameters parameter   {printf("\nparameters\n\n\n");}
    | 
    ;
parameter: 
    lBracket function_name parameters rBracket 	{printf("\nparameter1\n\n\n");}
    | identifier 	{printf("\nparameter: %s\n\n\n", $1);}
    | number 		{printf("\nparameter3\n\n\n");}
    | cString 		{printf("\nparameter: %s\n\n\n", $1);}
    | Boolean		{printf("\nparameter: %s\n\n\n", $1);}
    | lBracket predefined_function parameters rBracket	{printf("\nparameter6\n\n\n");}
    ;
number: 
    integer 	{printf("\nnumber1: %i\n\n\n", $1);}
    | Float	    {printf("\nnumber2: %f\n\n\n", $1);}
    ;

expression: 
    lBracket comparison_operator parameter parameter rBracket 	{printf("\nexpression1\n\n\n");}
    | lBracket Boolean_operator expression expression rBracket	{printf("\nexpression2\n\n\n");}
    | Boolean	{printf("\nexpression3\n\n\n");}
    ;
comparison_operator: 
    equalTo 	{printf("\noperator: %s\n\n\n", $1);}
    | greater 	{printf("\noperator: %s\n\n\n", $1);}
    | less 	    {printf("\noperator: %s\n\n\n", $1);}
    | gEqual 	{printf("\noperator: %s\n\n\n", $1);}
    | lEqual 	{printf("\noperator: %s\n\n\n", $1);}
    | notEqual	{printf("\noperator: %s\n\n\n", $1);}
    ;
Boolean_operator: 
    or 	    {printf("\noperator: %s\n\n\n", $1);}
    | and	{printf("\noperator: %s\n\n\n", $1);}
    ;
%%
int yyerror(char *s)
{
	return -1;
    /* Don't have to do anything! */
}
