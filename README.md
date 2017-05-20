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
* FP.l - The lex definition file from Project 1

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
[program]
  [{][Program][program-name:Sample][Function-definitions][statements][}]
    [function-definition][statement]
      [{][Function][function-name:facto][arguments][statements][return][return-arg:retVal][}][function-call]
        [argument:VAL][statement][{][predefined-function:print][parameters][}]
          [if-stmt][parameter]
            [{][if][expression][then][statements][else][statements][}][function-call]
              [{][comparison-operator:<][parameter:VAL][parameter][}][statement][statements][statement][{][function-name:facto][parameters][}]
                [number:0][assignment-stmt][statement][while-stmt][parameter]
                  [{][=][assignment-id:retVal][parameters][}][assignment-stmt][{][while][expression][do][statements][}][number:999]
                    [parameter][{][=][assignment-id:retVal][parameters][}][{][comparison-operator:>][parameter:VAL][parameter][}][statements][statement]
                      [number:-1][parameter][number:0][statement][assignment-stmt]
                        [number:1][assignment-stmt][{][=][assignment-id:VAL][parameters][}]
                          [{][=][assignment-id:retVal][parameters][}][parameter]
                            [parameter][function-call]
                              [function-call][{][predefined-function:-][parameters][}]
                                [{][predefined-function:*][parameters][}][parameters][parameter]
                                  [parameters][parameter:VAL][parameter:VAL][number:1]
                                    [parameter:retVal]
### Output Interpretation
Parse tree:
[program]
   _|__________________________________________________________________
   |     |              |                    |                 |      |
  [{][Program][program-name:Sample][Function-definitions][statements][}]
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
                        |                 |                 |               |________________________________________________________________
                        |                 |                 |_____________________________________      |           |               |       |
                        |                 |________________________________           |          |      |           |               |       |
               _________|___________________________________________      |           |          |      |           |               |       |
               |        |                   |               |      |      |           |          |      |           |               |       |
              [{][comparison-operator:<][parameter:VAL][parameter][}][statement][statements][statement][{][function-name:facto][parameters][}]
                    ________________________________________|             |           |          |                                  |
                    |               ______________________________________|           |          |                                  |
                    |               |           ______________________________________|          |                                  |
                    |               |           |           _____________________________________|                                  |
                    |               |           |           |           ____________________________________________________________|
                    |               |           |           |           |
                [number:0][assignment-stmt][statement][while-stmt][parameter]
                                    |           |           |           |_____________________________________________________
                                    |           |           |_________________________________________________________       |
                                    |           |______________________        |    |        |       |       |       |       |
                   _________________|_______________________          |        |    |        |       |       |       |       |
                   |  |             |               |      |          |        |    |        |       |       |       |       |
                  [{][=][assignment-id:retVal][parameters][}][assignment-stmt][{][while][expression][do][statements][}][number:999]
                         ___________________________|                 |                      |               |_____________________________________
                         |      ______________________________________|__  __________________|__________________________________       |          |
                         |      |  |            |               |       |  |            |                  |            |      |       |          |
                    [parameter][{][=][assignment-id:retVal][parameters][}][{][comparison-operator:>][parameter:VAL][parameter][}][statements][statement]
                         |            __________________________|                                                       |              |          |
                         |            |         ________________________________________________________________________|              |          |
                         |            |         |          ____________________________________________________________________________|          |
                         |            |         |          |            __________________________________________________________________________|
                         |            |         |          |            |
                      [number:-1][parameter][number:0][statement][assignment-stmt]
                            __________|   _________________|            |
                            |             |         ____________________|_________________
                            |             |         |  |        |               |        |
                        [number:1][assignment-stmt][{][=][assignment-id:VAL][parameters][}]
                           _______________|_________________________      ______|
                           |  |           |                 |      |      |
                          [{][=][assignment-id:retVal][parameters][}][parameter]
                                 ___________________________|             |
                                 |            ____________________________|
                                 |            |
                            [parameter][function-call]
                                 |            |______________________________________
                                 |            |            |                |       |
                              [function-call][{][predefined-function:-][parameters][}]
                                 |______________________________________    |____________
                                 |          |                   |      |    |           |
                                [{][predefined-function:*][parameters][}][parameters][parameter]
                                        ________________________|   ________|   ________|
                                        |            |              |           |
                                  [parameters][parameter:VAL][parameter:VAL][number:1]
                                        |
                                    [parameter:retVal]