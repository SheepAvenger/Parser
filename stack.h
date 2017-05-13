#ifndef HEADER_STACK
#define HEADER_STACK

#include <string.h>
#include <stdlib.h>

int pop_scope;
struct block
{
    int scope;
    struct block* next;

};

struct Stack
{
    struct block* head;
    void (*push)(struct block** b, int id);
    int (*pop)(struct block** b);
    void (*printStack)(struct block* h, char*);
    int (*peek)(struct block* h);

};

void push(struct block** b, int id)
{
    struct block* newBlock;
    if(!*b)
    {
        newBlock = malloc(sizeof(newBlock));
        newBlock->scope = id;
        newBlock->next = NULL;
        *b = newBlock;
    }
	else
    {
    	newBlock = malloc(sizeof(newBlock));
    	newBlock->next = *b;
    	newBlock->scope = id;
    	*b = newBlock;
    }
}

int pop(struct block** b)
{
    struct block* myTemp;
    myTemp = *b;
    int scope = myTemp->scope;
    *b = myTemp->next;
    return scope;
}

int peek(struct block* h)
{
    return h->scope;
}

void printStack(struct block* h, char* name)
{
    struct block* myBlock;
    if(h)
    {
        printf("%s Contents\n", name);
        myBlock = h;
        while(myBlock != NULL)
        {
            printf("Block ID: %i\n", myBlock->scope);
            myBlock = myBlock->next;
        }
		free(myBlock);
    }
}

#endif
