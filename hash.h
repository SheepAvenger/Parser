#ifndef HEADER_HASH
#define HEADER_HASH

#include "stack.h"
#include <stdio.h>

struct node
{
    char* Id;
    char* type;
    int scope;
    struct node* next;

};

struct Hash
{
    struct node **head;
    void (*insertToHash)(struct node**, char*, char*, int, long long);
    void (*display)(struct node**, int);
    void (*setSize)(struct node***, int);
    long long (*hashkey)(char*, int);
   struct  node* (*findInScope)(struct node**, char*, int, long long);
    struct node* (*findInGlobal)(struct node**, struct block* , char*, long long);
};

struct node * createNode(char *s, char *t, int scope)
 {
   struct node* newnode;
    newnode = malloc(sizeof(newnode));
    newnode->scope = scope;
    newnode->Id = malloc(strlen(s));
    strcpy(newnode->Id, s);
    newnode->type = malloc(strlen(t));
    strcpy(newnode->type, t);
    newnode->next = NULL;
    return newnode;
  };

long long hashkey(char* myString, int s)
{
    long long key;

	for (key = 1; *myString;)
	{
		key = (key*(long long)(*myString++)) % s;
	}
	return (key < 0 ? -key : key);
}

/*struct node** setSize(struct node** h, int s)
{
   h = malloc(s * sizeof(h));
    for(s = s-1; s >= 0; s--)
    {
        h[s] = NULL;
    }
    return h;
}*/

void setSize(struct node*** h, int s)
{
    struct node** myTemp = malloc(s * sizeof(myTemp));
    for(s = s-1; s >= 0; s--)
    {
        myTemp[s] = NULL;
    }
    *h = myTemp;
}

struct node* findInScope(struct node** h, char* myString, int scope, long long index)
{
    struct node *myNode = NULL;
    if (h[index] == NULL)
    {
        free(myNode);
        return myNode;
    }
    myNode = h[index];
    while(myNode != NULL)
    {
        if((strcmp(myNode->Id, myString) == 0) && (myNode->scope == scope))
        {
            return myNode;
        }
        myNode = myNode->next;
    }
    return myNode;
}

struct node* findInGlobal(struct node** h, struct block* b, char* myString, long long index)
{
    if (b == NULL)
    {
        return NULL;
    }
    struct node* myNode = NULL;
    struct block* myBlock = b;
    int i = 0;
    while(myBlock != NULL)
    {
        int scope = myBlock->scope;
        if ((myNode = findInScope(h, myString, scope, index)) != NULL)
        {
            return myNode;
        }
        myBlock = myBlock->next;
    }
    free(myBlock);
    return myNode;
}

 void insertToHash(struct node** h, char *myString, char *myType, int scope, long long hashIndex)
{
    struct node *newnode;
    newnode =  createNode(myString, myType, scope);

    if (!h[hashIndex])
        {
            h[hashIndex] = newnode;
            return;
        }
    newnode->next = h[hashIndex];
    h[hashIndex] = newnode;

  }

void display(struct node** h, int s)
{
    struct node *myNode;
    int i;
    for (i = 0; i < s; i++)
    {

        if (h[i])
        {
            myNode = h[i];
             printf("\nData at index %d in Symbol Table:\n", i);
            printf("Scope	Type                 String\n");
            printf("---------------------------------------\n");
            while (myNode != NULL)
            {
                printf("%-8d", myNode->scope);
                printf("%-21s", myNode->type);
		printf("%s\n", myNode->Id);
                myNode = myNode->next;
            }
        }

    }
    free(myNode);
    return;
  }

#endif
