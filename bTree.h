#ifndef HEADER_BTREE
#define HEADER_BTREE

#include <stdlib.h>
#include <stdio.h>
#include "FP.tab.h"

struct leaf
{
	int tokenType;
	struct leaf* leftParam;
	struct leaf* rightParam;
};

struct leaf* makeNode(int word, struct leaf* leftP, struct leaf* rightP) {
    struct leaf *node;
    node = malloc(sizeof(node));
    node->tokenType = word;
    node->rightParam = leftP;
    node->leftParam = rightP;
    return node;
}

void printTree(struct leaf* node)
{
	  switch (node->tokenType) {
    case identifier:
        printf("%i", node->tokenType);
        break;
    default:
        printf("(");
        printTree(node->leftParam);
        printf("%i", node->tokenType);
        printTree(node->rightParam);
        printf(")");
        break;
    }
}
#endif