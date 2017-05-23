%option noyywrap
%{
#include <math.h>
#include <stdio.h>
#include "scanner.h"
#include "bTree.h"
#include "hash.h"
#include "FP.tab.h"
#include "stack.h"
#define DEBUG 0
#define STDEBUG 0

void buildST(char*, char*);

struct Hash symbolTable = {NULL, insertToHash, display, setSize, hashkey, findInScope, findInGlobal};
struct Stack activeBlock = {NULL, push, pop, printStack, peek};
struct node* myNode = NULL;

int scope = 0;
long long key = 0;
extern int prime;
%}
/* 1.2 identifier, integer, float, character-string, Boolean */
ID          [a-zA-Z][a-zA-Z0-9]{0,5}
INT         (\-?[ \t\n]?[1-9][0-9]*)|0
FLOAT       (((\-?[ \t\n]?[1-9][0-9]*)|0)\.[0-9]+)|(\-[ \t\n]?0\.[0-9]*[1-9])
STRING      \([ a-zA-Z0-9\\]+\)
BOOLEAN     T|F
UNDEFINED   [a-zA-Z0-9]*|[^A-Za-z0-9\{|\}|\(|\)|\=|\+|\-|\*|\/|\%|\=\=|\>|\<|\>\=|\<\=|\!\= \t\n]*[a-zA-Z0-9]*|.
/* 1.4 White Space */
SPACE       [ \t\r\n]+
/* keywords and special symbols */
KEYWORD     Program|Function|return|if|then|else|while|do|or|and|print
SYMBOL      \{|\}|\(|\)|\=|\+|\-|\*|\/|\%|\=\=|\>|\<|\>\=|\<\=|\!\=
%%
{INT}       {yylval.strval = yytext; if(DEBUG){printf("[Lex] Integer: %s\n", yytext);}; buildST(yytext, "Integer"); return integer;}
{FLOAT}     {yylval.strval = yytext; if(DEBUG){printf("[Lex] Float: %s\n", yytext);}; buildST(yytext, "Float"); return Float;}
{KEYWORD}   {yylval.strval = yytext; if(DEBUG){printf("[Lex] Keyword: %s\n", yytext);}; if( strcmp(yytext, "Program") == 0)
		return prog;
	else if( strcmp(yytext, "Function") == 0)
		return func;
	else if( strcmp(yytext, "return") == 0)
		return ret;
	else if( strcmp(yytext, "if") == 0)
		return iif;
	else if( strcmp(yytext, "then") == 0)
		return then;
	else if( strcmp(yytext, "else") == 0)
		return els;
	else if( strcmp(yytext, "while") == 0)
		return whle;
	else if( strcmp(yytext, "do") == 0)
		return doo;
	else if( strcmp(yytext, "or") == 0)
		return or;
	else if( strcmp(yytext, "and") == 0)
		return and;
	else if( strcmp(yytext, "print") == 0)
		return print;}
{BOOLEAN}   {yylval.strval = yytext; if(DEBUG){printf("[Lex] Boolean: %s\n", yytext);}; buildST(yytext, "Boolean"); return Boolean;}
{ID}        {yylval.strval = yytext; if(DEBUG){printf("[Lex] Identifier: %s\n", yytext);}; buildST(yytext, "Identifier"); return identifier;}
{STRING}    {yylval.strval = yytext; if(DEBUG){printf("[Lex] char-String: %s\n", yytext);}; buildST(yytext, "Char-String"); return cString;}
{SYMBOL}    { if(DEBUG){printf("[Lex] Special Symbol: %s\n", yytext);}; if(strcmp(yytext, "{") == 0){
		buildST(yytext, "scope");
		return yytext[0];
	     }
	else if( strcmp(yytext, "}") == 0){
		buildST(yytext, "scope");
		return yytext[0];//return rBracket;
	}
	else if( strcmp(yytext, "(") == 0)
		return yytext[0];//return lParen;
	else if( strcmp(yytext, ")") == 0)
		return yytext[0];//return rParen;
	else if( strcmp(yytext, "=") == 0)
		return yytext[0];//return equal;
	else if( strcmp(yytext, "+") == 0)
		return yytext[0];
	else if( strcmp(yytext, "-") == 0)
		return yytext[0];
	else if( strcmp(yytext, "*") == 0)
		return yytext[0];
	else if( strcmp(yytext, "/") == 0)
		return yytext[0];
	else if( strcmp(yytext, "%") == 0)
		return yytext[0];
	else if( strcmp(yytext, "==") == 0)
	{
		yylval.strval = yytext;
		return equalTo;
	}
	else if( strcmp(yytext, ">") == 0)
		return yytext[0];
	else if( strcmp(yytext, "<") == 0)
		return yytext[0];
	else if( strcmp(yytext, "<=") == 0)
	{
		yylval.strval = yytext;
		return lEqual;
	}
	else if( strcmp(yytext, ">=") == 0)
	{
		yylval.strval = yytext;
		return gEqual;
	}
	else if( strcmp(yytext, "!=") == 0)
	{
		yylval.strval = yytext;
		return notEqual;
	}
	}
{SPACE}     //{return '\0';}/* skip whitespace */
{UNDEFINED} {if(DEBUG){printf("[Lex] Unrecognized: %s\n",yytext);}};
%%
void buildST(char* string, char* type)
{    
    if(STDEBUG){printf("Read %s, ", string);}      
    if(strcmp(string, "{") == 0)
    {
	activeBlock.push(&activeBlock.head, scope);
        if(STDEBUG)
        {
            printf("Scope %d pushed.\n", scope);
            activeBlock.printStack(activeBlock.head, "Active Block");
            printf("\n");
        }
        scope++;
    }
    else if(strcmp(string, "}") == 0)
    {
	int scope = activeBlock.pop(&activeBlock.head);
        if(STDEBUG)
        {
            printf("Scope %d popped.\n", scope);
            activeBlock.printStack(activeBlock.head, "Active Block");
            printf("\n");
        }
    }
    else
    {
        key = symbolTable.hashkey(string, prime);
        if(STDEBUG){printf("hashkey %lli, ", key);}

        if((myNode = symbolTable.findInScope(symbolTable.head, string, activeBlock.peek(activeBlock.head) , key)) == NULL)
        {
            // not found in current scope
            if(STDEBUG){printf("not found in current, ");}
            if((myNode = symbolTable.findInGlobal(symbolTable.head, activeBlock.head, string, key)) == NULL)
            {
                // not found in global scope
                symbolTable.insertToHash(symbolTable.head, string, type, activeBlock.peek(activeBlock.head), key);
                if(STDEBUG)
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
                if(STDEBUG){printf("found in global scope %d, won't insert.\n", myNode->scope);}
            }
        }
        else
        {
            // found in current scope
            if(STDEBUG){printf("found in current scope %d, won't insert.\n", activeBlock.peek(activeBlock.head));}
        }
    }
}

void createTable(int myPrime)
{
	prime = myPrime;
	symbolTable.setSize(&symbolTable.head, prime);
	symbolTable.setSize(&symbolTable.head, prime);
}
void printTable()
{
	symbolTable.display(symbolTable.head, prime);
}
void printBlocks()
{
	activeBlock.printStack(activeBlock.head, "Active Block");
}
char* searchTable(long long hashIndex, char* myString, char* myType)
{
	struct node *myNode = NULL;
    	if (symbolTable.head[hashIndex] == NULL)
    	{
        	return NULL;
    	}
    	myNode = symbolTable.head[hashIndex];
    	while(myNode != NULL)
	{
		if(strcmp(myNode->Id, myString) == 0)
		{
			//printf("id: %s  myString: %s\n", myNode->Id, myString);
			myNode->type = (myType == NULL || strcmp(myType, "program") == 0 ? myNode->type : myType);
			return myNode->Id;
		}
		else
			myNode = myNode->next;
	}
}
long long getKey(char* ptr)
{
	return symbolTable.hashkey(ptr, prime);
}