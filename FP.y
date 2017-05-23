%{
#include <stdio.h> 
#include <stdlib.h> 
#include <stdarg.h> 
#include "scanner.h"
#include "bTree.h"
#define DEBUG 0

int yylex();
tNode* addLeaf(int, char*, char*);
tNode* addNode(char*, int, ...);
int yyerror(char*);

extern struct node* myNode;
extern int prime;
tNode* root = NULL;
%}
%start program  /* The Start-Symbol */
%union {
    char* strval;
    tNode* nPtr;
}
/* Nonterminal Symbols (type <strval> will be changed to <nPtr>) */
%type <nPtr> program program_name function_definitions function_definition function_name
%type <nPtr> arguments argument return_arg statements statement assignment_stmt function_call
%type <nPtr> predefined_function parameters parameter number if_stmt while_stmt
%type <nPtr> expression comparison_operator Boolean_operator Identifiers expression_id
/* Terminal Symbols */ 
%token <strval> Float integer
%token <strval> identifier cString Boolean lBracket rBracket lParen rParen
%token <strval> equal plus minus mult divide mod equalTo greater less gEqual lEqual notEqual
%token <strval> prog func ret iif then els whle doo and or print 
//%right "then" "else"
%%
program: 
    '{' prog program_name function_definitions statements '}' {if(DEBUG){printf("[Yacc] \nstart\n");}; $$=addNode("program",6, addLeaf(0, "{", NULL), addLeaf(0, "Program", NULL), $3, $4, $5, addLeaf(0, "}", NULL)); root = $$;}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
program_name: 
    identifier  {if(DEBUG){printf("[Yacc] \nprogram-name %s\n\n\n", $1);}; $$=addLeaf(1, "program-name", $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
function_definitions: 
    function_definitions function_definition    {if(DEBUG){printf("[Yacc] \nfunction-definitions\n\n\n");}; $$=addNode("function-definitions",2, $1, $2);}
    | {$$ = NULL;}
    ;
function_definition:
    '{' func function_name arguments statements ret return_arg '}'    {if(DEBUG){printf("[Yacc] \nfunction-definition\n\n\n");}; $$=addNode("function-definition", 8, addLeaf(0, "{", NULL), addLeaf(0, "Function", NULL), $3, $4, $5, addLeaf(0, "return", NULL), $7, addLeaf(0, "}", NULL));}
    ;
function_name: 
    identifier  {if(DEBUG){printf("[Yacc] \nfunction-name %s\n\n\n", $1);}; $$=addLeaf(1, "function-name",$1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
arguments: 
    arguments argument  {if(DEBUG){printf("[Yacc] \narguments\n\n\n");}; $$=addNode("arguments",2, $1, $2);}
    | {$$ = NULL;}
    ;
argument: 
    identifier  {if(DEBUG){printf("[Yacc] \nargument %s\n\n\n", $1);}; $$=addLeaf(1, "argument", $1);}
    ;
return_arg: 
    identifier  {if(DEBUG){printf("[Yacc] \nreturn-arg %s\n\n\n", $1);}; $$=addLeaf(1, "return-arg", $1);}
    | {$$ = NULL;}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
statements: 
    statements statement    {if(DEBUG){printf("[Yacc] \nstatements\n\n\n");}; $$=addNode("statements", 2, $1, $2);}
    | statement             {if(DEBUG){printf("[Yacc] \nstatements\n\n\n");}; $$=addNode("statements", 1, $1);} 
    ;
statement:
    assignment_stmt {$$=addNode("statement", 1, $1);} 
    | function_call {$$=addNode("statement", 1, $1);}
    | if_stmt       {$$=addNode("statement", 1, $1);}
    | while_stmt    {$$=addNode("statement", 1, $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
assignment_stmt:
    '{' '=' Identifiers parameter '}'       {if(DEBUG){printf("[Yacc] \nassignment_stmt: \n\n\n");}; $$=addNode("assignment-stmt", 5, addLeaf(0, "{", NULL), addLeaf(0, "assignment-operator","="), $3, $4, addLeaf(0, "}", NULL));}
    ;
function_call:
    '{' function_name parameters '}'        {if(DEBUG){printf("[Yacc] \nfunction_call1\n\n\n");}; $$=addNode("function-call", 4, addLeaf(0, "{", NULL), $2, $3, addLeaf(0, "}", NULL));}
    | '{' predefined_function parameters '}'  {if(DEBUG){printf("[Yacc] \nfunction_call2\n\n\n");}; $$=addNode("function-call", 4, addLeaf(0, "{", NULL), $2, $3, addLeaf(0, "}", NULL));}
    ;
predefined_function: 
    '+' 	    {if(DEBUG){printf("[Yacc] \nplus\n\n\n");}; $$=addLeaf(0, "predefined-function", "+");}
    | '-' 	{if(DEBUG){printf("[Yacc] \nminus\n\n\n");}; $$=addLeaf(0, "predefined-function", "-");}
    | '*' 	    {if(DEBUG){printf("[Yacc] \nmult\n\n\n");}; $$=addLeaf(0, "predefined-function", "*");}
    | '/' 	{if(DEBUG){printf("[Yacc] \ndivide\n\n\n");}; $$=addLeaf(0, "predefined-function", "/");}
    | '%' 	    {if(DEBUG){printf("[Yacc] \nmod\n\n\n");}; $$=addLeaf(0, "predefined-function", "%");}
    | print	    {if(DEBUG){printf("[Yacc] \nprint\n\n\n");}; $$=addLeaf(0, "predefined-function", "print");}
    ;
parameters: 
    parameters parameter   {if(DEBUG){printf("[Yacc] \nparameters\n\n\n");}; $$=addNode("parameters", 2, $1, $2);}
    | {$$ = NULL;}
    ;
parameter: 
    function_call   {$$=addNode("parameter", 1, $1);}
    | identifier    {if(DEBUG){printf("[Yacc] \nparameter: %s\n\n\n", $1);}; $$=addLeaf(1, "parameter", $1);}
    | number        {if(DEBUG){printf("[Yacc] \nparameter3\n\n\n");}; $$=addNode("parameter", 1, $1);}
    | cString       {if(DEBUG){printf("[Yacc] \nparameter: %s\n\n\n", $1);}; $$=addLeaf(1, "parameter", $1);}
    | Boolean       {if(DEBUG){printf("[Yacc] \nparameter: %s\n\n\n", $1);}; $$=addLeaf(1, "parameter", $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
number: 
    integer     {if(DEBUG){printf("[Yacc] \nnumber1: %s\n\n\n", $1);}; $$ = addLeaf(1, "number", $1);}
    | Float     {if(DEBUG){printf("[Yacc] \nnumber2: %s\n\n\n", $1);}; $$ = addLeaf(1, "number", $1);}
    ;
if_stmt:
    '{' iif expression then statements els statements '}'   {if(DEBUG){printf("[Yacc] \nif_stmt\n\n\n");}; $$=addNode("if-stmt", 8, addLeaf(0, "{", NULL), addLeaf(0, "if", NULL), $3, addLeaf(0, "then", NULL), $5, addLeaf(0, "else", NULL), $7, addLeaf(0, "}", NULL));}
    ;
while_stmt:
    '{' whle expression doo statements '}'  {if(DEBUG){printf("[Yacc] \nwhile_stmt\n\n\n");}; $$=addNode("while-stmt", 6, addLeaf(0, "{", NULL), addLeaf(0, "while", NULL), $3, addLeaf(0, "do", NULL), $5, addLeaf(0, "}", NULL));}
    ;
expression_id:
    function_call   {$$=addNode("expression-id", 1, $1);}
    | identifier    {if(DEBUG){printf("[Yacc] \nexpression-id: %s\n\n\n", $1);}; $$=addLeaf(1, "expression-id", $1);}
    | number        {if(DEBUG){printf("[Yacc] \nexpression-id3\n\n\n");}; $$=addNode("expression-id", 1, $1);}
    | cString       {if(DEBUG){printf("[Yacc] \nexpression-id: %s\n\n\n", $1);}; $$=addLeaf(1, "expression-id", $1);}
    | Boolean       {if(DEBUG){printf("[Yacc] \nexpression-id: %s\n\n\n", $1);}; $$=addLeaf(1, "expression-id", $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
expression: 
    '{' comparison_operator expression_id expression_id '}'   {if(DEBUG){printf("[Yacc] \nexpression1\n\n\n");}; $$=addNode("expression", 5, addLeaf(0, "{", NULL), $2, $3, $4, addLeaf(0, "}", NULL));}
    | '{' Boolean_operator expression expression '}'  {if(DEBUG){printf("[Yacc] \nexpression2\n\n\n");}; $$=addNode("expression", 5, addLeaf(0, "{", NULL), $2, $3, $4, addLeaf(0, "}", NULL));}
    | Boolean   {if(DEBUG){printf("[Yacc] \nexpression3\n\n\n");}; $$=addLeaf(1, "expression", $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
comparison_operator: 
    equalTo     {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf(0, "comparison-operator", "==");}
    | '>'   {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", ">");}; $$=addLeaf(0, "comparison-operator", ">");}
    | '<'      {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", "<");}; $$=addLeaf(0, "comparison-operator", "<");}
    | gEqual    {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf(0, "comparison-operator", ">=");}
    | lEqual    {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf(0, "comparison-operator", "<=");}
    | notEqual  {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf(0, "comparison-operator", "!=");}
    ;
Boolean_operator: 
    or      {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf(0, "Boolean-operator", "or");}
    | and   {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf(0, "Boolean-operator", "and");}
    ;
Identifiers:
	identifier	{$$ = addLeaf(1, "assignment-id", $1);};
%%
tNode* addLeaf(int id_flag, char* label, char* ptr) 
{ 
    long long key = 0;   
    tNode *p; 
    if ((p = malloc(sizeof(tNode))) == NULL) 
        yyerror("malloc error"); 
    p->label = label;
    p->type = t; 
	if(id_flag)
    {
        key = getKey(ptr);
        p->term.ptr = searchTable(key, ptr, label);
    }
	else
		p->term.ptr = ptr; 
    {if(DEBUG)printf("Adding: %s, from: %s\n", p->term.ptr, label);}
    return p; 
} 
tNode* addNode(char* label, int num_args, ...) 
{
    va_list ap; 
    tNode *p; 
    int i; 
    if ((p = malloc(sizeof(tNode))) == NULL)
        yyerror("malloc error"); 
    p->label = label;
    p->type = nt; 
    p->nonTerm.num_child = num_args; 
    tNode** myTemp = malloc(num_args * sizeof(myTemp));
    va_start(ap, num_args); 
    for (i = 0; i < num_args; i++) 
        myTemp[i] = va_arg(ap, tNode*);
    va_end(ap); 
	p->nonTerm.child = myTemp;
    return p; 
} 
int yyerror(char *s)
{
    //if(DEBUG){fprintf(stdout, "%s\n", s);
	return -1;
    /* Don't have to do anything! */
}