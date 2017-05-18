#ifndef HEADER_SCANNER
#define HEADER_SCANNER

void createTable(int);
void printTable();
void printBlocks();
long long getKey(char*);
char* searchTable(long long hashIndex, char* myString, char* myType);

#endif