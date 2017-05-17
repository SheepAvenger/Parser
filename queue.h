#ifndef HEADER_QUEUE
#define HEADER_QUEUE

#include <stdio.h>
#include <stdlib.h>
#include "bTree.h"

typedef struct qNodeTag
{
    tNode* data;
    struct qNodeTag *next;
}qNode;

qNode* front = NULL;
qNode* rear = NULL;
int qSize = 0;

void enqueue(tNode* data)
{
    qNode* temp;
    if((temp = malloc(sizeof(qNode))) == NULL) 
    {
        printf("malloc error");
        return;
    }        
    temp->data = data;
    temp->next = NULL;
    if(front == NULL)
    {   
        front = rear = temp;
    }
    else
    {
        rear->next = temp;
        rear = temp;
    }
    qSize++;
}
tNode* dequeue()
{
    qNode* temp;
    tNode* retval;
    temp = front;
    if(front == NULL)
    {   
        return NULL;
    }
    else if(front == rear)
    {
        front = rear = NULL;
    }
    else
    {
        front = front->next;
    }
    qSize--;
    retval = temp->data;
    free(temp);
    return retval;
}
int size()
{
    return qSize;
}

#endif