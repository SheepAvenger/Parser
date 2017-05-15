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
%start program  /* The Start-Symbol */
%union {
    char* strval;
    int intval;
    float fltval;
    //node* nPtr;
}
/* Nonterminal Symbols (type <strval> will be changed to <nPtr>) */
%type <strval> program program_name function_definitions function_definition function_name
%type <strval> arguments argument return_arg statements statement
//%type <strval> assignment_stmt function_call
%type <strval> predefined_function parameters parameter number
//%type <strval> if_stmt while_stmt
%type <strval> expression comparison_operator Boolean_operator
/* Terminal Symbols */ 
%token <intval> integer
%token <fltval> Float
%token <strval> identifier cString Boolean lBracket rBracket lParen rParen 
%token <strval> equal plus minus mult divide mod equalTo greater less gEqual lEqual notEqual
%token <strval> prog func ret iif then els whle doo and or print 
//%right "then" "else"
%%
program: 
    lBracket prog program_name function_definitions statements rBracket {if(DEBUG){printf("[Yacc] \nstart\n");};}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
program_name: 
    identifier  {if(DEBUG){printf("[Yacc] \nprogram-name %s\n\n\n", $1);};$$=$1;}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
function_definitions: 
    function_definitions function_definition    {if(DEBUG){printf("[Yacc] \nfunction-definitions\n\n\n");};}
    | {$$ = NULL;}
    ;
function_definition:
    lBracket func function_name arguments statements ret return_arg rBracket    {if(DEBUG){printf("[Yacc] \nfunction-definition\n\n\n");};}
    ;
function_name: 
    identifier  {if(DEBUG){printf("[Yacc] \nfunction-name %s\n\n\n", $1);};}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
arguments: 
    arguments argument  {if(DEBUG){printf("[Yacc] \narguments\n\n\n");};}
    | {$$ = NULL;}
    ;
argument: 
    identifier  {if(DEBUG){printf("[Yacc] \nargument %s\n\n\n", $1);};}
    ;
return_arg: 
    identifier  {if(DEBUG){printf("[Yacc] \nreturn-arg %s\n\n\n", $1);};}
    | {$$ = NULL;}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
statements: 
    statements statement    {if(DEBUG){printf("[Yacc] \nstatements\n\n\n");};}
    | statement             {if(DEBUG){printf("[Yacc] \nstatement\n\n\n");};} 
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
statement:
    lBracket equal identifier parameters rBracket       {if(DEBUG){printf("[Yacc] \nassignment_stmt\n\n\n");};}
    | lBracket predefined_function parameters rBracket  {if(DEBUG){printf("[Yacc] \nfunction_call2\n\n\n");};}
    | lBracket iif expression then statements els statements rBracket   {if(DEBUG){printf("[Yacc] \nif_stmt\n\n\n");};}
    | lBracket whle expression doo statements rBracket  {if(DEBUG){printf("[Yacc] \nwhile_stmt\n\n\n");};}
    | lBracket function_name parameters rBracket        {if(DEBUG){printf("[Yacc] \nfunction_call1\n\n\n");};}
    ;
predefined_function: 
    plus 	    {if(DEBUG){printf("[Yacc] \nplus\n\n\n");};}
    | minus 	{if(DEBUG){printf("[Yacc] \nminus\n\n\n");};}
    | mult 	    {if(DEBUG){printf("[Yacc] \nmult\n\n\n");};}
    | divide 	{if(DEBUG){printf("[Yacc] \ndivide\n\n\n");};}
    | mod 	    {if(DEBUG){printf("[Yacc] \nmod\n\n\n");};}
    | print	    {if(DEBUG){printf("[Yacc] \nprint\n\n\n");};}
    ;
parameters: 
    parameters parameter   {if(DEBUG){printf("[Yacc] \nparameters\n\n\n");};}
    | {$$ = NULL;}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
parameter: 
    lBracket function_name parameters rBracket          {if(DEBUG){printf("[Yacc] \nparameter1\n\n\n");};}
    | identifier    {if(DEBUG){printf("[Yacc] \nparameter: %s\n\n\n", $1);};}
    | number        {if(DEBUG){printf("[Yacc] \nparameter3\n\n\n");};}
    | cString       {if(DEBUG){printf("[Yacc] \nparameter: %s\n\n\n", $1);};}
    | Boolean       {if(DEBUG){printf("[Yacc] \nparameter: %s\n\n\n", $1);};}
    | lBracket predefined_function parameters rBracket  {if(DEBUG){printf("[Yacc] \nparameter6\n\n\n");};}
    ;
number: 
    integer     {if(DEBUG){printf("[Yacc] \nnumber1: %i\n\n\n", $1);};}
    | Float     {if(DEBUG){printf("[Yacc] \nnumber2: %f\n\n\n", $1);};}
    ;
expression: 
    lBracket comparison_operator parameter parameter rBracket   {if(DEBUG){printf("[Yacc] \nexpression1\n\n\n");};}
    | lBracket Boolean_operator expression expression rBracket  {if(DEBUG){printf("[Yacc] \nexpression2\n\n\n");};}
    | Boolean   {if(DEBUG){printf("[Yacc] \nexpression3\n\n\n");};}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
comparison_operator: 
    equalTo     {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);};}
    | greater   {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);};}
    | less      {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);};}
    | gEqual    {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);};}
    | lEqual    {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);};}
    | notEqual  {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);};}
    ;
Boolean_operator: 
    or      {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);};}
    | and   {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);};}
    ;
%%
int yyerror(char *s)
{
    //if(DEBUG){fprintf(stdout, "%s\n", s);
	return -1;
    /* Don't have to do anything! */
}