Project Phase 2 - Syntax analysis (Due on May 17)
## Team Members
kw5854 - Robert McCook
pg4425 - Jon Quianzon
hf6233 - Hongjie Zhu

## Environment
```
Lex: flex 2.5.35, 2.6.0, 2.6.1
Yacc: Bison 3.0.4
Language: C
OS: Ubuntu 16.10, CentOS 6.8
IDE/Editor: Notepad++ v7, VIM 7.4.1829
Compiler: gcc 4.4.7, 5.4.0, 6.2.0
```

## Components and Functions
### hash.h - The symbol table modified from Project 0
### stack.h - The active scope number stack from Project 0
### FP.l - The lex definition file from Project 1
###

## Assumptions
* if then else
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
### Output Interpretation