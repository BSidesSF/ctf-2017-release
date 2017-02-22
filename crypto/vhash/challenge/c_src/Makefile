CC=gcc

#CFLAGS=-Wall -march=native -O3
#CFLAGS=-Wall -O2 -g
#CFLAGS=-Wall -march=native -O2 -pg
#CFLAGS=-Wall -march=native -O0 -g
CFLAGS=-Wall -O0 -g

main: vhash

vhash: vhash.o
	$(CC) $(CFLAGS) -o vhash vhash.o

vhash.o: vhash.c
	$(CC) $(CFLAGS) -c vhash.c

clean:
	rm -f vhash
	rm -f *.o
	rm -f *~
	rm -f \#*
