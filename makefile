# # For Windows System
# lexer.exe:lex.yy.c
# 	gcc lex.yy.c -o lexer

# # For Windows System
# lex.yy.c:mylex.l
# 	flex mylex.l

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