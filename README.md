# Compiler Design Programming Assignment
**Objective** : 
* To develop a lexical analyzer for a programming language.
* To understand importance of a symbol table.
* To learn a tool Lex: lexical analyzer generator.

**Implementation** : The Symbol Table is simulated using a ***Chained HashMap*** where each Token class has a unique HashValue. Each index of the HashMap therefore stores a List containing all the Tokens (of that particular type). Each Token has a member ***_class*** which stores the Token Class and a member ***attributes*** which is the value/name of the Token.

These are the various *HashValues* or *_class* of the different Tokens that can be detected using this program
```
#define KEYWORD 0
#define ID 1
#define RELOP 2
#define LOGICALOP 3
#define ARITHMOP 4
#define ASSIGNOP 5
#define WHOLE_NUM_CONSTANT 6
#define REAL_CONSTANT 7
#define CHAR_CONSTANT 8
#define STRING_CONSTANT 9
#define PREPROC 10
```
## Structure of Lex Program
1. **Description Section :** In the Description section, the Data Structure to hold the tokens i.e. the Symbol table and basic Definitions of Regular Expressions have been provided.

2. **Rules Section :** Contains the rules and the corresponding code to be executed upon matching of various Regular Expressions. 

3. **Subroutines Section :**  Contains the various auxillary functions that are necessary for the program and the main method.


## Input Format

The executable file ***lexer*** can be executed either by entering the input through terminal or by passing a file as an argument using the command.
`./lexer {filename.extension}`

Four programs provided : *prog1.c, prog2.c, prog3.c, prog4.c* can be used to test the executable lexer.
<br>

#### Makefile
The ***makefile*** can be used to generate the executable lexer.

```makefile
# For Windows System
lexer.exe:lex.yy.c
	gcc lex.yy.c -o lexer

# For Windows System
lex.yy.c:mylex.l
	flex mylex.l

# For Linux System
lexer:lex.yy.c
	gcc lex.yy.c -ll -o lexer

# For Linux System
lex.yy.c:mylex.l
	lex mylex.l

# To Clear the executable files in a Linux System
clear_linux:
	rm lex.yy.c
	rm lexer	

# To Clear the executable files in Windows cmd
clear_win:
	del lex.yy.c
	del lexer.exe
```

**Note :** Although I have tried my best to detect most of the possible tokens there can be discrepancies which might occur in the output.
