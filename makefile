calc : bison flex
	gcc -o calc y.tab.c lex.yy.c

flex :	
	flex calc.l

bison:
	bison --yacc -dv calc.y

clean:	
	rm -rf *.c *.output *.h calc
	

	
