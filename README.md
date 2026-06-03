# Lexer-i-parser
Lekser i parser w technologii Flex i Bison.

W celu kompilacji:

$bison -d parser.y
$flex lekser.l
&gcc parser.tab.h lex.yy.c
