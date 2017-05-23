#include<stdlib.h>
#include<stdio.h>
#include "bTree.h"
#include "FP.tab.h"
#include "scanner.h"
#include "queue.h"
#define DEBUG 0
void printTree(tNode*);
void freeNode(tNode*);
int isPrime(int p);
int prime;

void main()
{
    FILE *yyin = stdin;
    long int size;
    fseek(yyin, 1, SEEK_END);
    size = ftell(yyin);
    rewind(yyin);
    if(size > 271)
    {
        size /= 16;
        prime = size -1;
        for(; ; prime--)
        {
            if(isPrime(prime))
            break;
        }
    }
    else
        prime = 13; // default prime for file size smaller than 272
    if(DEBUG) {printf("Prime: %d\n\n", prime);}    
    createTable(prime);
    
    do {
        int t = yyparse();
	 if(DEBUG) {printf("t %i\n", t);}
    } while(!feof(yyin));
	fclose(yyin);
    printf("\n========= Finished reading the input file =========\n");
	printTable();
	  
    printf("\n");   
	printBlocks(); 
    printf("\n");
    if(root)
    {
        printTree(root);
        freeNode(root);
    }
}
void printTree(tNode* p)
{
    int count, num_child, i , indent;
    indent = 2;
    tNode* t;
    enqueue(p);
    count = qSize;
    while(qSize != 0)
    {
        t = dequeue();
        if(t == NULL){
            //printf("[]");   /* For debugging*/
        }    
        else if(t->type == nt)
        {
            printf("[%s]", t->label); 
            num_child = t->nonTerm.num_child;
            for(i = 0; i < num_child; i++)
            {
                enqueue(t->nonTerm.child[i]);
            }
        }
        else
        {
            if(t->label && t->term.ptr)
            {
                printf("[%s:%s]", t->label, t->term.ptr);
            }
            else if(!t->label)
            {
                printf("[%s]", t->term.ptr);
            }
            else
            {
                printf("[%s]", t->label);
            }
        }
        count--;
        if(count == 0)
        {
            //printf("\n\timage %d branches here", qSize); 
            printf("\n");
            for(i=0; i < indent; i++)
            {
                printf(" ");
            }
            indent += 2;
            count = qSize;
        }
    }
    printf("\n");
}
void freeNode(tNode* p) 
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
int isPrime(int p)
{
    int i;
    for(i = 2; p%i != 0; i++);
    if(p==i)
        return 1;
    else
        return 0;
}
