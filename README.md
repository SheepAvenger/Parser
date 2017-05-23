# Project Phase 2 - Syntax analysis

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
* FP.l - The lex definition modified from Project 1
* FP.y - Yacc file for parsing tokens from lex, builds parse tree
* driver.c - Main file that calls yyparse and prints the symbol table, active block stack and parse tree

## Constraint
* This program is fully tested in Ubuntu. We assume this program will work in Linux-like systems, but not in Windows-like systems.

## Compile and Run in Linux
Put all the files in the same directory 
Launch a Terminal, navigate to the directory that contains the files described above, execute following commands
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
### Input - sample.fp
{Program Sample
    {Function facto VAL
        {if {< VAL 0 }
        then {= retVal -1}
        else {= retVal 1}
            {while {> VAL 0} do
                {= retVal {* retVal VAL}}
                {= VAL {- VAL 1}}
            }
        }
        return retVal
    }
    {print {facto 999}}
}
### Output - output.txt
========= Finished reading the input file =========

Data at index 0 in Symbol Table:
Scope	Type                 Value
---------------------------------------
13      function-name        facto
1       function-name        facto

Data at index 8 in Symbol Table:
Scope	Type                 Value
---------------------------------------
1       return-arg           retVal
8       parameter            retVal
5       assignment-id        retVal
4       assignment-id        retVal

Data at index 10 in Symbol Table:
Scope	Type                 Value
---------------------------------------
1       parameter            VAL

Data at index 12 in Symbol Table:
Scope	Type                 Value
---------------------------------------
13      number               999
4       number               -1

Data at index 14 in Symbol Table:
Scope	Type                 Value
---------------------------------------
7       number               0
3       number               0

Data at index 15 in Symbol Table:
Scope	Type                 Value
---------------------------------------
11      number               1
5       number               1

Data at index 16 in Symbol Table:
Scope	Type                 Value
---------------------------------------
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
For better reading the tree structure, please use Notepad or Notepad++ with the Word wrap option off.
Each node is in square brackets []
The parse tree structure of the output can be interpreted as below:
Depth
 0    [program]
         _|__________________________________________________________________
         |     |              |                    |                 |      |
 1      [{][Program][program-name:Sample][function-definitions][statements][}]
                    _______________________________|                 |
                    |               _________________________________|
                    |               |
 2        [function-definition][statement]
                    |               |______________________________________________________________________
             _______|_____________________________________________________________________________        |
             |      |               |              |          |          |            |          |        |
 3          [{][Function][function-name:facto][arguments][statements][return][return-arg:retVal][}][function-call]
                     ______________________________|          |                                           |
                     |            ____________________________|                                           |
                     |            |     __________________________________________________________________|
                     |            |     |             |                   |       |
 4            [argument:VAL][statement][{][predefined-function:print][parameters][}]
                   _______________|                                       |
                   |          ____________________________________________|
                   |          |
 5              [if-stmt][parameter]
                   |          |____________________________________________________
                   |_______________________________________________________       |
                   |   |      |        |        |        |        |       |       |
 6                [{][if][expression][then][statements][else][statements][}][function-call]
                              |                 |                 |               |________________________________________________________________________
                              |                 |                 |_____________________________________________      |           |               |       |
                              |                 |________________________________________           |          |      |           |               |       |
                     _________|___________________________________________________      |           |          |      |           |               |       |
                     |        |                   |                   |          |      |           |          |      |           |               |       |
 7                  [{][comparison-operator:<][expression-id:VAL][expression-id][}][statement][statements][statement][{][function-name:facto][parameters][}]
                          ____________________________________________|                 |           |          |                                  |
                          |               ______________________________________________|           |          |                                  |
                          |               |           ______________________________________________|          |                                  |
                          |               |           |           _____________________________________________|                                  |
                          |               |           |           |           ____________________________________________________________________|
                          |               |           |           |           |
 8                    [number:0][assignment-stmt][statement][while-stmt][parameter]
                                          |           |           |           |________________________________________________________________________
                                          |           |           |____________________________________________________________________________       |
                                          |           |_________________________________________        |    |        |       |       |       |       |
                         _________________|__________________________________________          |        |    |        |       |       |       |       |
                         |                |                  |               |      |          |        |    |        |       |       |       |       |
 9                      [{][assignment-operator:=][assignment-id:retVal][parameter][}][assignment-stmt][{][while][expression][do][statements][}][number:999]
                               ______________________________________________|                 |                      |               |____________________________________________
                               |      _________________________________________________________|__  __________________|__________________________________________      |          |
                               |      |            |                    |                |       |  |            |                  |                   |       |      |          |
10                        [number:-1][{][assignment-operator:=][assignment-id:retVal][parameter][}][{][comparison-operator:>][expression-id:VAL][expression-id][}][statements][statement]
                               __________________________________________________________|                                                              |              |          |
                               |            ____________________________________________________________________________________________________________|              |          |
                               |            |         _________________________________________________________________________________________________________________|          |
                               |            |         |          _________________________________________________________________________________________________________________|
                               |            |         |          |
11                          [number:1][number:0][statement][assignment-stmt]
                                      ________________|          |
                                      |         _________________|_______________________________________
                                      |         |             |                   |              |      |
12                            [assignment-stmt][{][assignment-operator:=][assignment-id:VAL][parameter][}]
                                 _____|______________________________________________________    |
                                 |            |                    |                 |      |    |
13                              [{][assignment-operator:=][assignment-id:retVal][parameter][}][function-call]
                                       ______________________________________________|           |
                                       |          _______________________________________________|
                                       |          |             |                |      |
14                                [function-call][{][predefined-function:-][parameters][}]
                                     __|____________________________________     |____________
                                     |          |                   |      |     |           |
15                                  [{][predefined-function:*][parameters][}][parameters][parameter]
                                            ________________________|   ________|   ________|
                                            |            |              |           |
16                                    [parameters][parameter:VAL][parameter:VAL][number:1]
                                            |
17                                      [parameter:retVal]
