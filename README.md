# Fractures-Lexer-and-Parser
Lexer in Flex and parser in Bison for oprations on fractures.
Supports addition, substraction, multiplication, divisions and parentheses.

Building:

$bison -d parser.y

$flex lekser.l

$gcc parser.tab.h lex.yy.c
