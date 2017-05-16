#ifndef HEADER_BTREE
#define HEADER_BTREE

typedef enum { t, nt } nodeEnum; 

typedef struct 
{ 
    char* ptr;  /* point to ST */
} terminal; 

typedef struct 
{ 
    int num_child;  /* number of children */ 
    struct nodeTag *child[1];  /* children */ 
} nonTerminal; 

typedef struct nodeTag 
{ 
    nodeEnum type;  /* type of node */ 
    union { 
        terminal term;
        nonTerminal nonTerm;
    }; 
} nodeType; 
#endif