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
//%right "then" "else"
%%
program: 
    lBracket prog program_name function_definitions statements rBracket {if(DEBUG){printf("\nstart\n");};}
    | error {printf("Failure :-(\n"); yyerrok; yyclearin;}
    ;
program_name: 
    identifier  {if(DEBUG){printf("\nprogram-name %s\n\n\n", $1);};}
    | error {printf("Failure :-(\n"); yyerrok; yyclearin;}
    ;
function_definitions: 
    function_definitions function_definition    {if(DEBUG){printf("\nfunction-definitions\n\n\n");};}
    | 
    ;
function_definition:
    lBracket func function_name arguments statements ret return_arg rBracket    {if(DEBUG){printf("\nfunction-definition\n\n\n");};}
    ;
function_name: 
    identifier  {if(DEBUG){printf("\nfunction-name %s\n\n\n", $1);};}
    | error {printf("Failure :-(\n"); yyerrok; yyclearin;}
    ;
arguments: 
    arguments argument  {if(DEBUG){printf("\narguments\n\n\n");};}
    | 
    ;
argument: 
    identifier  {if(DEBUG){printf("\nargument %s\n\n\n", $1);};}
    ;
return_arg: 
    identifier  {if(DEBUG){printf("\nreturn-arg %s\n\n\n", $1);};}
    | 
    | error {printf("Failure :-(\n"); yyerrok; yyclearin;}
    ;
statements: 
    statements statement    {if(DEBUG){printf("\nstatements\n\n\n");};}
    | statement             {if(DEBUG){printf("\nstatement\n\n\n");};} 
    | error {printf("Failure :-(\n"); yyerrok; yyclearin;}
    ;
statement:
    lBracket equal identifier parameters rBracket       {if(DEBUG){printf("\nassignment_stmt\n\n\n");};}
    | lBracket predefined_function parameters rBracket  {if(DEBUG){printf("\nfunction_call2\n\n\n");};}
    | lBracket iif expression then statements els statements rBracket   {if(DEBUG){printf("\nif_stmt\n\n\n");};}
    | lBracket whle expression doo statements rBracket  {if(DEBUG){printf("\nwhile_stmt\n\n\n");};}
    | lBracket function_name parameters rBracket        {if(DEBUG){printf("\nfunction_call1\n\n\n");};}
    ;
predefined_function: 
    plus 	    {if(DEBUG){printf("\nplus\n\n\n");};}
    | minus 	{if(DEBUG){printf("\nminus\n\n\n");};}
    | mult 	    {if(DEBUG){printf("\nmult\n\n\n");};}
    | divide 	{if(DEBUG){printf("\ndivide\n\n\n");};}
    | mod 	    {if(DEBUG){printf("\nmod\n\n\n");};}
    | print	    {if(DEBUG){printf("\nprint\n\n\n");};}
    ;
parameters: 
    parameters parameter   {if(DEBUG){printf("\nparameters\n\n\n");};}
    | 
    | error {printf("Failure :-(\n"); yyerrok; yyclearin;}
    ;
parameter: 
    lBracket function_name parameters rBracket          {if(DEBUG){printf("\nparameter1\n\n\n");};}
    | identifier    {if(DEBUG){printf("\nparameter: %s\n\n\n", $1);};}
    | number        {if(DEBUG){printf("\nparameter3\n\n\n");};}
    | cString       {if(DEBUG){printf("\nparameter: %s\n\n\n", $1);};}
    | Boolean       {if(DEBUG){printf("\nparameter: %s\n\n\n", $1);};}
    | lBracket predefined_function parameters rBracket  {if(DEBUG){printf("\nparameter6\n\n\n");};}
    ;
number: 
    integer     {if(DEBUG){printf("\nnumber1: %i\n\n\n", $1);};}
    | Float     {if(DEBUG){printf("\nnumber2: %f\n\n\n", $1);};}
    ;
expression: 
    lBracket comparison_operator parameter parameter rBracket   {if(DEBUG){printf("\nexpression1\n\n\n");};}
    | lBracket Boolean_operator expression expression rBracket  {if(DEBUG){printf("\nexpression2\n\n\n");};}
    | Boolean   {if(DEBUG){printf("\nexpression3\n\n\n");};}
    | error {printf("Failure :-(\n"); yyerrok; yyclearin;}
    ;
comparison_operator: 
    equalTo     {if(DEBUG){printf("\noperator: %s\n\n\n", $1);};}
    | greater   {if(DEBUG){printf("\noperator: %s\n\n\n", $1);};}
    | less      {if(DEBUG){printf("\noperator: %s\n\n\n", $1);};}
    | gEqual    {if(DEBUG){printf("\noperator: %s\n\n\n", $1);};}
    | lEqual    {if(DEBUG){printf("\noperator: %s\n\n\n", $1);};}
    | notEqual  {if(DEBUG){printf("\noperator: %s\n\n\n", $1);};}
    ;
Boolean_operator: 
    or      {if(DEBUG){printf("\noperator: %s\n\n\n", $1);};}
    | and   {if(DEBUG){printf("\noperator: %s\n\n\n", $1);};}
    ;
%%
int yyerror(char *s)
{
    //fif(DEBUG){printf(stdout, "%s\n", s);
	return -1;
    /* Don't have to do anything! */
}