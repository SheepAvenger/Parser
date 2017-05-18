#ifndef HEADER_BTREE
#define HEADER_BTREE

#include <stdlib.h>
#include <stdio.h>

typedef enum { t, nt } nodeEnum; 

typedef struct 
{ 
    char* ptr;  /* point to ST */
} terminal; 

typedef struct 
{ 
    int num_child;  /* number of children */ 
    struct nodeTag* *child;  /* children */ 
} nonTerminal; 

typedef struct nodeTag 
{ 
    char* label;
    nodeEnum type;  /* type of node */ 
    union { 
        terminal term;
        nonTerminal nonTerm;
    }; 
} tNode; 

extern tNode* root;
#endif