%{
#include <stdio.h> 
#include <stdlib.h> 
#include <stdarg.h> 
#include "scanner.h"
#include "bTree.h"
#define DEBUG 0

int yylex();
tNode* addLeaf(char*, char*);
tNode* addNode(char*, int, ...);
//void freeNode(tNode* p);
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
%type <nPtr> expression comparison_operator Boolean_operator Identifiers
/* Terminal Symbols */ 
%token <strval> Float integer
%token <strval> identifier cString Boolean lBracket rBracket lParen rParen
%token <strval> equal plus minus mult divide mod equalTo greater less gEqual lEqual notEqual
%token <strval> prog func ret iif then els whle doo and or print 
//%right "then" "else"
%%
program: 
    '{' prog program_name function_definitions statements '}' {if(DEBUG){printf("[Yacc] \nstart\n");}; $$=addNode("program",6, addLeaf("{", "{"), addLeaf("program", "Program"), $3, $4, $5, addLeaf("}", "}")); root = $$;}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
program_name: 
    identifier  {if(DEBUG){printf("[Yacc] \nprogram-name %s\n\n\n", $1);}; $$=addLeaf("program-name", $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
function_definitions: 
    function_definitions function_definition    {if(DEBUG){printf("[Yacc] \nfunction-definitions\n\n\n");}; $$=addNode("Function-definitions",2, $1, $2);}
    | {$$ = NULL;}
    ;
function_definition:
    '{' func function_name arguments statements ret return_arg '}'    {if(DEBUG){printf("[Yacc] \nfunction-definition\n\n\n");}; $$=addNode("function-definition", 8, addLeaf(NULL,"{"), addLeaf(NULL,"Function"), $3, $4, $5, addLeaf(NULL,"return"), $7, addLeaf(NULL,"}"));}
    ;
function_name: 
    identifier  {if(DEBUG){printf("[Yacc] \nfunction-name %s\n\n\n", $1);}; $$=addLeaf("function-name",$1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
arguments: 
    arguments argument  {if(DEBUG){printf("[Yacc] \narguments\n\n\n");}; $$=addNode("arguments",2, $1, $2);}
    | {$$ = NULL;}
    ;
argument: 
    identifier  {if(DEBUG){printf("[Yacc] \nargument %s\n\n\n", $1);}; $$=addLeaf("argument", $1);}
    ;
return_arg: 
    identifier  {if(DEBUG){printf("[Yacc] \nreturn-arg %s\n\n\n", $1);}; $$=addLeaf("return-arg", $1);}
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
    '{' '=' Identifiers parameters '}'       {if(DEBUG){printf("[Yacc] \nassignment_stmt: \n\n\n");}; $$=addNode("assignment-stmt", 5, addLeaf("{", "{"), addLeaf("=","="), $3, $4, addLeaf("}","}"));}
    ;
function_call:
    '{' function_name parameters '}'        {if(DEBUG){printf("[Yacc] \nfunction_call1\n\n\n");}; $$=addNode("function-call", 4, addLeaf(NULL,"{"), $2, $3, addLeaf(NULL,"}"));}
    | '{' predefined_function parameters '}'  {if(DEBUG){printf("[Yacc] \nfunction_call2\n\n\n");}; $$=addNode("function-call", 4, addLeaf(NULL,"{"), $2, $3, addLeaf(NULL,"}"));}
    ;
predefined_function: 
    '+' 	    {if(DEBUG){printf("[Yacc] \nplus\n\n\n");}; $$=addLeaf("predefined-function", "+");}
    | '-' 	{if(DEBUG){printf("[Yacc] \nminus\n\n\n");}; $$=addLeaf("predefined-function", "-");}
    | '*' 	    {if(DEBUG){printf("[Yacc] \nmult\n\n\n");}; $$=addLeaf("predefined-function", "*");}
    | '/' 	{if(DEBUG){printf("[Yacc] \ndivide\n\n\n");}; $$=addLeaf("predefined-function", "/");}
    | '%' 	    {if(DEBUG){printf("[Yacc] \nmod\n\n\n");}; $$=addLeaf("predefined-function", "%");}
    | print	    {if(DEBUG){printf("[Yacc] \nprint\n\n\n");}; $$=addLeaf("predefined-function", $1);}
    ;
parameters: 
    parameters parameter   {if(DEBUG){printf("[Yacc] \nparameters\n\n\n");}; $$=addNode("parameters", 2, $1, $2);}
    | {$$ = NULL;}
    ;
parameter: 
    function_call   {$$=addNode("parameter", 1, $1);}
    | identifier    {if(DEBUG){printf("[Yacc] \nparameter: %s\n\n\n", $1);}; $$=addLeaf("parameter", $1);}
    | number        {if(DEBUG){printf("[Yacc] \nparameter3\n\n\n");}; $$=addNode("parameter", 1, $1);}
    | cString       {if(DEBUG){printf("[Yacc] \nparameter: %s\n\n\n", $1);}; $$=addLeaf("parameter", $1);}
    | Boolean       {if(DEBUG){printf("[Yacc] \nparameter: %s\n\n\n", $1);}; $$=addLeaf("parameter", $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
number: 
    integer     {if(DEBUG){printf("[Yacc] \nnumber1: %s\n\n\n", $1);}; $$ = addLeaf("number", $1);}
    | Float     {if(DEBUG){printf("[Yacc] \nnumber2: %s\n\n\n", $1);}; $$ = addLeaf("number", $1);}
    ;
if_stmt:
    '{' iif expression then statements els statements '}'   {if(DEBUG){printf("[Yacc] \nif_stmt\n\n\n");}; $$=addNode("if-stmt", 8, addLeaf(NULL,"{"), addLeaf(NULL,"if"), $3, addLeaf(NULL,"then"), $5, addLeaf(NULL,"else"), $7, addLeaf(NULL,"}"));}
    ;
while_stmt:
    '{' whle expression doo statements '}'  {if(DEBUG){printf("[Yacc] \nwhile_stmt\n\n\n");}; $$=addNode("while-stmt", 6, addLeaf(NULL,"{"), addLeaf(NULL,"while"), $3, addLeaf(NULL,"do"), $5, addLeaf(NULL,"}"));}
    ;
expression: 
    '{' comparison_operator parameter parameter '}'   {if(DEBUG){printf("[Yacc] \nexpression1\n\n\n");}; $$=addNode("expression", 5, addLeaf(NULL,"{"), $2, $3, $4, addLeaf(NULL,"}"));}
    | '{' Boolean_operator expression expression '}'  {if(DEBUG){printf("[Yacc] \nexpression2\n\n\n");}; $$=addNode("expression", 5, addLeaf(NULL,"{"), $2, $3, $4, addLeaf(NULL,"}"));}
    | Boolean   {if(DEBUG){printf("[Yacc] \nexpression3\n\n\n");}; $$=addLeaf("expression", $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
comparison_operator: 
    equalTo     {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf("comparison-operator", $1);}
    | '>'   {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", ">");}; $$=addLeaf("comparison-operator", ">");}
    | '<'      {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", "<");}; $$=addLeaf("comparison-operator", "<");}
    | gEqual    {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf("comparison-operator", $1);}
    | lEqual    {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf("comparison-operator", $1);}
    | notEqual  {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf("comparison-operator", $1);}
    ;
Boolean_operator: 
    or      {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf("Boolean-operator", $1);}
    | and   {if(DEBUG){printf("[Yacc] \noperator: %s\n\n\n", $1);}; $$=addLeaf("Boolean-operator", $1);}
    ;
Identifiers:
	identifier	{$$ = addLeaf("assignment-id", $1);};
%%
tNode* addLeaf(char* label, char* ptr) 
{ 
    long long key = 0;
    key = getKey(ptr);
    tNode *p; 
    if ((p = malloc(sizeof(tNode))) == NULL) 
        yyerror("malloc error"); 
    p->label = label;
    p->type = t; 
	if(ptr[0] != '{' && ptr[0] != '}')
    		p->term.ptr = searchTable(key, ptr, label);
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
    if ((p = malloc(sizeof(tNode) + (num_args-1) * sizeof(tNode *))) == NULL) 
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
/*void freeNode(tNode* p) 
{ 
    int i; 
    if (!p) return; 
    if (p->type == nt) 
    { 
        for (i = 0; i < p->nonTerm.num_child; i++) 
            freeNode(p->nonTerm.child[i]); 
    }
    free (p); 
} */
int yyerror(char *s)
{
    //if(DEBUG){fprintf(stdout, "%s\n", s);
	return -1;
    /* Don't have to do anything! */
}