#Project Phase 2 - Syntax analysis (Due on May 22)
## Team Members
kw5854 - Robert McCook
pg4425 - Jon Quianzon
hf6233 - Hongjie Zhu

## Environment
```
Lex: flex 2.5.35, 2.6.0, 2.6.1
Yacc: Bison 2.4.1, 3.0.4
Language: C
OS: Ubuntu 16.10, CentOS 6.8
IDE/Editor: Notepad++ v7, VIM 7.4.1829
Compiler: gcc 4.4.7, 5.4.0, 6.2.0
```

## Components and Functions
* hash.h - The symbol table modified from Project 0
* stack.h - The active scope number stack from Project 0
* bTree.h - Header file for building a parse tree
* scanner.h - Header file to allow FP.l, FP.y and driver.c to cross communicate
* queue.h - Header file to build a queue for printing the parse tree
* FP.l - The lex definition file from Project 1
* FP.y - Yacc file for parsing tokens from lex, builds parse tree
* driver.c - Main file that calls yyparse and prints the symbol table, active block stack and parse tree

## Constraint
* The if statement in this language only allows if-then-else format.
* This program is fully tested in Ubuntu. We assume this program will work in Linux-like systems, but not in Windows-like systems.

## Compile and Run in Linux
Put all the files in the same directory 
Launch a Terminal, navigate to the directory that contains the files described above, execute following command
```
flex FP.l
bison -d FP.y
gcc FP.tab.c lex.yy.c driver.c
```
Execute the program with an input sample file
```
./a.out < sample.fp
```

## Test
### Input
See sample.fp
### Output
========= Finished reading the input file =========

Data at index 0 in Symbol Table:
Scope	Type                 Value
---------------------------------------
13      function-name        facto
6       KeyWord              while
2       KeyWord              if
1       function-name        facto

Data at index 3 in Symbol Table:
Scope	Type                 Value
---------------------------------------
0       KeyWord              Program

Data at index 7 in Symbol Table:
Scope	Type                 Value
---------------------------------------
1       KeyWord              return

Data at index 8 in Symbol Table:
Scope	Type                 Value
---------------------------------------
1       return-arg           retVal
9       predefined-function  *
8       parameter            retVal
5       assignment-id        retVal
4       assignment-id        retVal

Data at index 9 in Symbol Table:
Scope	Type                 Value
---------------------------------------
3       comparison-operator  <

Data at index 10 in Symbol Table:
Scope	Type                 Value
---------------------------------------
10      assignment-operator  =
8       assignment-operator  =
5       assignment-operator  =
2       KeyWord              else
4       assignment-operator  =
1       parameter            VAL

Data at index 11 in Symbol Table:
Scope	Type                 Value
---------------------------------------
11      predefined-function  -
7       comparison-operator  >

Data at index 12 in Symbol Table:
Scope	Type                 Value
---------------------------------------
13      number               999
4       number               -1
1       KeyWord              Function

Data at index 13 in Symbol Table:
Scope	Type                 Value
---------------------------------------
12      predefined-function  print

Data at index 14 in Symbol Table:
Scope	Type                 Value
---------------------------------------
7       number               0
2       KeyWord              then
3       number               0

Data at index 15 in Symbol Table:
Scope	Type                 Value
---------------------------------------
11      number               1
5       number               1

Data at index 16 in Symbol Table:
Scope	Type                 Value
---------------------------------------
6       KeyWord              do
0       program-name         Sample


[program]
  [{][Program][program-name:Sample][function-definitions][statements][}]
    [function-definition][statement]
      [{][Function][function-name:facto][arguments][statements][return][return-arg:retVal][}][function-call]
        [argument:VAL][statement][{][predefined-function:print][parameters][}]
          [if-stmt][parameter]
            [{][if][expression][then][statements][else][statements][}][function-call]
              [{][comparison-operator:<][expression-id:VAL][expression-id][}][statement][statements][statement][{][function-name:facto][parameters][}]
                [number:0][assignment-stmt][statement][while-stmt][parameter]
                  [{][assignment-operator:=][assignment-id:retVal][parameter][}][assignment-stmt][{][while][expression][do][statements][}][number:999]
                    [number:-1][{][assignment-operator:=][assignment-id:retVal][parameter][}][{][comparison-operator:>][expression-id:VAL][expression-id][}][statements][statement]
                      [number:1][number:0][statement][assignment-stmt]
                        [assignment-stmt][{][assignment-operator:=][assignment-id:VAL][parameter][}]
                          [{][assignment-operator:=][assignment-id:retVal][parameter][}][function-call]
                            [function-call][{][predefined-function:-][parameters][}]
                              [{][predefined-function:*][parameters][}][parameters][parameter]
                                [parameters][parameter:VAL][parameter:VAL][number:1]
                                  [parameter:retVal]

### Output Interpretation
Parse tree:
[program]
   _|__________________________________________________________________
   |     |              |                    |                 |      |
  [{][Program][program-name:Sample][function-definitions][statements][}]
              _______________________________|                 |
              |               _________________________________|
              |               |
    [function-definition][statement]
              |               |______________________________________________________________________
       _______|_____________________________________________________________________________        |
       |      |               |              |          |          |            |          |        |
      [{][Function][function-name:facto][arguments][statements][return][return-arg:retVal][}][function-call]
               ______________________________|          |                                           |
               |            ____________________________|                                           |
               |            |     __________________________________________________________________|
               |            |     |             |                   |       |
        [argument:VAL][statement][{][predefined-function:print][parameters][}]
             _______________|                                       |
             |          ____________________________________________|
             |          |
          [if-stmt][parameter]
             |          |____________________________________________________
             |_______________________________________________________       |
             |   |      |        |        |        |        |       |       |
            [{][if][expression][then][statements][else][statements][}][function-call]
                        |                 |                 |               |________________________________________________________________________
                        |                 |                 |_____________________________________________      |           |               |       |
                        |                 |________________________________________           |          |      |           |               |       |
               _________|___________________________________________________      |           |          |      |           |               |       |
               |        |                   |                   |          |      |           |          |      |           |               |       |
              [{][comparison-operator:<][expression-id:VAL][expression-id][}][statement][statements][statement][{][function-name:facto][parameters][}]
                    ____________________________________________|                 |           |          |                                  |
                    |               ______________________________________________|           |          |                                  |
                    |               |           ______________________________________________|          |                                  |
                    |               |           |           _____________________________________________|                                  |
                    |               |           |           |           ____________________________________________________________________|
                    |               |           |           |           |
                [number:0][assignment-stmt][statement][while-stmt][parameter]
                                    |           |           |           |________________________________________________________________________
                                    |           |           |____________________________________________________________________________       |
                                    |           |_________________________________________        |    |        |       |       |       |       |
                   _________________|__________________________________________          |        |    |        |       |       |       |       |
                   |                |                  |               |      |          |        |    |        |       |       |       |       |
                  [{][assignment-operator:=][assignment-id:retVal][parameter][}][assignment-stmt][{][while][expression][do][statements][}][number:999]
                         ______________________________________________|                 |                      |               |____________________________________________
                         |      _________________________________________________________|__  __________________|__________________________________________      |          |
                         |      |            |                    |                |       |  |            |                  |                   |       |      |          |
                    [number:-1][{][assignment-operator:=][assignment-id:retVal][parameter][}][{][comparison-operator:>][expression-id:VAL][expression-id][}][statements][statement]
                         __________________________________________________________|                                                              |              |          |
                         |            ____________________________________________________________________________________________________________|              |          |
                         |            |         _________________________________________________________________________________________________________________|          |
                         |            |         |          _________________________________________________________________________________________________________________|
                         |            |         |          |
                      [number:1][number:0][statement][assignment-stmt]
                                ________________|          |
                                |         _________________|_______________________________________
                                |         |             |                   |              |      |
                        [assignment-stmt][{][assignment-operator:=][assignment-id:VAL][parameter][}]
                           _____|______________________________________________________    |
                           |            |                    |                 |      |    |
                          [{][assignment-operator:=][assignment-id:retVal][parameter][}][function-call]
                                 ______________________________________________|           |
                                 |          _______________________________________________|
                                 |          |             |                |      |
                            [function-call][{][predefined-function:-][parameters][}]
                               __|____________________________________     |____________
                               |          |                   |      |     |           |
                              [{][predefined-function:*][parameters][}][parameters][parameter]
                                      ________________________|   ________|   ________|
                                      |            |              |           |
                                [parameters][parameter:VAL][parameter:VAL][number:1]
                                      |
                                  [parameter:retVal]
