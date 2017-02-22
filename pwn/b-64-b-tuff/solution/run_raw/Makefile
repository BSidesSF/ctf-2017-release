CC?=gcc
LIBS?=
CFLAGS?=-m32

all: run_raw

run_raw: run_raw.o
	${CC} ${CFLAGS} -o run_raw run_raw.o ${LIBS}

clean:
	rm -fv *.o run_raw core core.*
