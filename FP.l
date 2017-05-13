%option noyywrap
%{
#include <math.h>
#include "FP.tab.h"

#define DEBUG 0

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
{INT}       {char *ptr; yylval.intval = strtoul(yytext, &ptr, 10); printf("Integer: %s\n", yytext); return integer;}
{FLOAT}     {yylval.fltval = atof(yytext); printf("Float: %s\n", yytext); return Float;}
{KEYWORD}   {yylval.strval = yytext; printf("Keyword: %s\n", yytext);  if( strcmp(yytext, "Program") == 0)
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
{BOOLEAN}   {yylval.strval = yytext; printf("Boolean: %s\n", yytext); return Boolean;}
{ID}        {yylval.strval = yytext; printf("Identifier: %s\n", yytext); return identifier;}
{STRING}    {yylval.strval = yytext; printf("char-String: %s\n", yytext); return string;}
{SYMBOL}    {yylval.strval = yytext; printf("Special Symbol: %s\n", yytext); if(strcmp(yytext, "{") == 0)
		return lBracket;
	else if( strcmp(yytext, "}") == 0)
		return rBracket;
	else if( strcmp(yytext, "(") == 0)
		return lParen;
	else if( strcmp(yytext, ")") == 0)
		return rParen;
	else if( strcmp(yytext, "=") == 0)
		return equal;
	else if( strcmp(yytext, "+") == 0)
		return plus;
	else if( strcmp(yytext, "-") == 0)
		return minus;
	else if( strcmp(yytext, "*") == 0)
		return mult;
	else if( strcmp(yytext, "/") == 0)
		return divide;
	else if( strcmp(yytext, "%") == 0)
		return mod;
	else if( strcmp(yytext, "==") == 0)
		return equalTo;
	else if( strcmp(yytext, ">") == 0)
		return greater;
	else if( strcmp(yytext, "<") == 0)
		return less;
	else if( strcmp(yytext, "<=") == 0)
		return lEqual;
	else if( strcmp(yytext, ">=") == 0)
		return gEqual;
	else if( strcmp(yytext, "!=") == 0)
		return notEqual;}
{SPACE}     /* skip whitespace */
{UNDEFINED} printf("Unrecognized: %s\n",yytext);
%%