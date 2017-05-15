//#include "lex.yy.c"
#include<stdlib.h>
#include<stdio.h>
#include "FP.tab.h"
#include "scanner.h"
#define DEBUG 0

int isPrime(int p);
int myPrime;

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
        myPrime = size -1;
        for(; ; myPrime--)
        {
            if(isPrime(myPrime))
            break;
        }
    }
    else
        myPrime = 13; // default prime for file size smaller than 272
    if(DEBUG) {printf("Prime: %d\n\n", myPrime);}    
    createTable(myPrime);
    
    do {
        int t = yyparse();
	printf("t %i\n", t);
    } while(!feof(yyin));
	fclose(yyin);
    printf("\n========= Finished reading the input file =========\n");
	printTable();
	  
    printf("\n");   
	printBlocks(); 
    
}

int isPrime(int p)
{
    int i;
    for(i = 2; p%i != 0; i++);
    if(p==i)
        return 1;
    else
        return 0;
}