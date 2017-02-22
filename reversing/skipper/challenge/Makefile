all: skipper

skipper:
	gcc -m32 -funroll-all-loops -o skipper-32 skipper.c
	gcc -m64 -funroll-all-loops -o skipper-64 skipper.c
	strip skipper-32
	strip skipper-64

cheat:
	gcc -DTEST1 -DTEST2 -DTEST3 -funroll-all-loops -o skipper-cheat skipper.c

clean:
	rm -f *.o core *.stackdump *.exe skipper-*
