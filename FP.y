%{
#include <stdio.h> 
#include <stdlib.h> 
#include <stdarg.h> 
#include "bTree.h"
#define DEBUG 1

int yylex();
tNode* addLeaf(char* label, char* ptr);
tNode* addNode(char* label, int num_args, ...);
int yyerror(char*);
tNode* root = NULL;
%}
%start program  /* The Start-Symbol */
%union {
    char* strval;
    int intval;
    float fltval;
    tNode* nPtr;
}
/* Nonterminal Symbols */
%type <nPtr> program program_name function_definitions function_definition function_name
%type <nPtr> arguments argument return_arg statements statement assignment_stmt function_call
%type <nPtr> predefined_function parameters parameter number if_stmt while_stmt
%type <nPtr> expression comparison_operator Boolean_operator
/* Terminal Symbols */ 
%token <intval> integer
%token <fltval> Float
%token <strval> identifier cString Boolean lBracket rBracket lParen rParen 
%token <strval> equal plus minus mult divide mod equalTo greater less gEqual lEqual notEqual
%token <strval> prog func ret iif then els whle doo and or print 
//%right "then" "else"
%%
program: 
    lBracket prog program_name function_definitions statements rBracket {if(DEBUG){printf("[Yacc] start\n");}; $$=addNode("program", 6, addLeaf(NULL, $1), addLeaf(NULL, $2), $3, $4, $5, addLeaf(NULL, $6)); root = $$;}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
program_name: 
    identifier  {if(DEBUG){printf("[Yacc] program-name %s\n", $1);}; $$=addLeaf("program-name", $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
function_definitions: 
    function_definitions function_definition    {if(DEBUG){printf("[Yacc] function-definitions\n");}; $$=addNode("function-definitions", 2, $1, $2);}
    | {$$ = NULL;}
    ;
function_definition:
    lBracket func function_name arguments statements ret return_arg rBracket    {if(DEBUG){printf("[Yacc] function-definition\n");}; $$=addNode("function-definition", 8, addLeaf(NULL, $1), addLeaf(NULL, $2), $3, $4, $5, addLeaf(NULL, $6), $7, addLeaf(NULL, $8));}
    ;
function_name: 
    identifier  {if(DEBUG){printf("[Yacc] function-name %s\n", $1);}; $$=addLeaf("function-name", $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
arguments: 
    arguments argument  {if(DEBUG){printf("[Yacc] arguments\n");}; $$=addNode("arguments", 2, $1, $2);}
    | {$$ = NULL;}
    ;
argument: 
    identifier  {if(DEBUG){printf("[Yacc] argument %s\n", $1);}; $$=addLeaf("argument", $1);}
    ;
return_arg: 
    identifier  {if(DEBUG){printf("[Yacc] return-arg %s\n", $1);}; $$=addLeaf("return-arg", $1);}
    | {$$ = NULL;}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
statements: 
    statements statement    {if(DEBUG){printf("[Yacc] statements\n");}; $$=addNode("statements", 2, $1, $2);}
    | statement             {if(DEBUG){printf("[Yacc] statement\n");}; $$=addNode("statements", 1, $1);}
    ;
statement:
    assignment_stmt {if(DEBUG){printf("[Yacc] statement\n");}; $$=addNode("statement", 1, $1);} 
    | function_call {if(DEBUG){printf("[Yacc] statement\n");}; $$=addNode("statement", 1, $1);}
    | if_stmt       {if(DEBUG){printf("[Yacc] statement\n");}; $$=addNode("statement", 1, $1);}
    | while_stmt    {if(DEBUG){printf("[Yacc] statement\n");}; $$=addNode("statement", 1, $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
assignment_stmt:
    lBracket equal identifier parameters rBracket       {if(DEBUG){printf("[Yacc] assignment_stmt\n");}; $$=addNode("assignment-stmt", 5, addLeaf("{", $1), addLeaf("=", $2), addLeaf("assignment-id", $3), $4, addLeaf("}", $5));}
    ;
function_call:
    lBracket function_name parameters rBracket        {if(DEBUG){printf("[Yacc] function_call1\n");}; $$=addNode("function-call", 4, addLeaf(NULL, $1), $2, $3, addLeaf(NULL, $4));}
    | lBracket predefined_function parameters rBracket  {if(DEBUG){printf("[Yacc] function_call2\n");}; $$=addNode("function-call", 4, addLeaf(NULL, $1), $2, $3, addLeaf(NULL, $4));}
    ;
predefined_function: 
    plus 	    {if(DEBUG){printf("[Yacc] plus\n");}; $$=addLeaf("predefined-function", $1);}
    | minus 	{if(DEBUG){printf("[Yacc] minus\n");}; $$=addLeaf("predefined-function", $1);}
    | mult 	    {if(DEBUG){printf("[Yacc] mult\n");}; $$=addLeaf("predefined-function", $1);}
    | divide 	{if(DEBUG){printf("[Yacc] divide\n");}; $$=addLeaf("predefined-function", $1);}
    | mod 	    {if(DEBUG){printf("[Yacc] mod\n");}; $$=addLeaf("predefined-function", $1);}
    | print	    {if(DEBUG){printf("[Yacc] print\n");}; $$=addLeaf("predefined-function", $1);}
    ;
parameters: 
    parameters parameter   {if(DEBUG){printf("[Yacc] parameters\n");}; $$=addNode("parameters", 2, $1, $2);}
    | {$$ = NULL;}
    ;
parameter: 
    function_call   {$$=addNode("parameter", 1, $1);}
    | identifier    {if(DEBUG){printf("[Yacc] parameter: %s\n", $1);}; $$=addLeaf("parameter", $1);}
    | number        {if(DEBUG){printf("[Yacc] parameter3\n");}; $$=addNode("parameter", 1, $1);}
    | cString       {if(DEBUG){printf("[Yacc] parameter: %s\n", $1);}; $$=addLeaf("parameter", $1);}
    | Boolean       {if(DEBUG){printf("[Yacc] parameter: %s\n", $1);}; $$=addLeaf("parameter", $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
number: 
    integer     {if(DEBUG){printf("[Yacc] number1: %i\n", $1);}; char word[25]; sprintf(word, "%i", $1); $$ = addLeaf("number", word);}
    | Float     {if(DEBUG){printf("[Yacc] number2: %f\n", $1);}; char word[25]; sprintf(word, "%f", $1); $$ = addLeaf("number", word);}
    ;
if_stmt:
    lBracket iif expression then statements els statements rBracket   {if(DEBUG){printf("[Yacc] if_stmt\n");}; $$=addNode("if-stmt", 8, addLeaf(NULL, $1), addLeaf(NULL, $2), $3, addLeaf(NULL, $4), $5, addLeaf(NULL, $6), $7, addLeaf(NULL, $8));}
    ;
while_stmt:
    lBracket whle expression doo statements rBracket  {if(DEBUG){printf("[Yacc] while_stmt\n");}; $$=addNode("while-stmt", 6, addLeaf(NULL, $1), addLeaf(NULL, $2), $3, addLeaf(NULL, $4), $5, addLeaf(NULL, $6));}
    ;
expression: 
    lBracket comparison_operator parameter parameter rBracket   {if(DEBUG){printf("[Yacc] expression1\n");}; $$=addNode("expression", 5, addLeaf(NULL, $1), $2, $3, $4, addLeaf(NULL, $5));}
    | lBracket Boolean_operator expression expression rBracket  {if(DEBUG){printf("[Yacc] expression2\n");}; $$=addNode("expression", 5, addLeaf(NULL, $1), $2, $3, $4, addLeaf(NULL, $5));}
    | Boolean   {if(DEBUG){printf("[Yacc] expression3\n");}; $$=addLeaf("expression", $1);}
    | error {printf("[Yacc] Failure :-(\n"); yyerrok; yyclearin;}
    ;
comparison_operator: 
    equalTo     {if(DEBUG){printf("[Yacc] operator: %s\n", $1);}; $$=addLeaf("comparison-operator", $1);}
    | greater   {if(DEBUG){printf("[Yacc] operator: %s\n", $1);}; $$=addLeaf("comparison-operator", $1);}
    | less      {if(DEBUG){printf("[Yacc] operator: %s\n", $1);}; $$=addLeaf("comparison-operator", $1);}
    | gEqual    {if(DEBUG){printf("[Yacc] operator: %s\n", $1);}; $$=addLeaf("comparison-operator", $1);}
    | lEqual    {if(DEBUG){printf("[Yacc] operator: %s\n", $1);}; $$=addLeaf("comparison-operator", $1);}
    | notEqual  {if(DEBUG){printf("[Yacc] operator: %s\n", $1);}; $$=addLeaf("comparison-operator", $1);}
    ;
Boolean_operator: 
    or      {if(DEBUG){printf("[Yacc] operator: %s\n", $1);}; $$=addLeaf("Boolean-operator", $1);}
    | and   {if(DEBUG){printf("[Yacc] operator: %s\n", $1);}; $$=addLeaf("Boolean-operator", $1);}
    ;
%%
tNode* addLeaf(char* label, char* ptr) 
{ 
    printf("Adding %s\n", ptr);
    tNode *p; 
    if ((p = malloc(sizeof(tNode))) == NULL) 
        yyerror("malloc error"); 
    p->label = label;
    p->type = t; 
    p->term.ptr = ptr; 
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
    va_start(ap, num_args); 
    for (i = 0; i < num_args; i++) 
        p->nonTerm.child[i] = va_arg(ap, tNode*); 
    va_end(ap); 
    return p; 
} 
int yyerror(char *s)
{
    //if(DEBUG){fprintf(stdout, "%s\n", s);
	return -1;
    /* Don't have to do anything! */
}