all: burczyk_pawlicki

burczyk_pawlicki: burczyk_pawlicki.tab.c lex.yy.c 
	gcc -o burczyk_pawlicki lex.yy.c burczyk_pawlicki.tab.c

lex.yy.c: burczyk_pawlicki.l
	flex burczyk_pawlicki.l
	
burczyk_pawlicki.tab.c: burczyk_pawlicki.y
	bison -d burczyk_pawlicki.y
	
clean:
	rm lex.yy.c
	rm burczyk_pawlicki.tab.c
	rm burczyk_pawlicki.tab.h
	rm *~
	rm burczyk_pawlicki
