#include<stdlib.h>
#include<stdio.h>
#include "bTree.h"
#include "FP.tab.h"
#include "scanner.h"
#define DEBUG 0

int isPrime(int p);
void printTree(nodeType* p);
void freeNode(nodeType* p);
int myPrime;

void main()
{
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
    printTree(root);
    freeNode(root);
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

void printTree(nodeType* p)
{
    int i, num_child;
    if(p == NULL){return;}
    if(p->type == nt)
    {
        num_child = p->nonTerm.num_child;
        for(i = 0; i < num_child; i++)
        {
            printTree(p->nonTerm.child[i]);
        }
    }
    else
    {
        printf("%s ", p->term.ptr);
    }
}

void freeNode(nodeType* p) 
{ 
    int i; 
    if (!p) return; 
    if (p->type == nt) 
    { 
        for (i = 0; i < p->nonTerm.num_child; i++) 
            freeNode(p->nonTerm.child[i]); 
    }
    free (p); 
} 
