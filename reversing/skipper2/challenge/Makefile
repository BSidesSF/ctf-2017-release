all: skipper2

skipper2:
	gcc -m32 -funroll-all-loops -o skipper2-32 skipper2.c
	gcc -m64 -funroll-all-loops -o skipper2-64 skipper2.c
	gcc -DTEST1 -DTEST2 -DTEST3 -o skipper2-cheat skipper2.c

clean:
	rm -f *.o core *.stackdump *.exe skipper2-*
