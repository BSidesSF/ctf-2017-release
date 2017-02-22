CC?=gcc
LIBS?=
OBJS=b-64-b-tuff.o

all: b-64-b-tuff

b-64-b-tuff: b-64-b-tuff.o
	${CC} -m32 -o b-64-b-tuff b-64-b-tuff.o ${LIBS}

b-64-b-tuff.o:
	${CC} -m32 -c -o b-64-b-tuff.o b-64-b-tuff.c

clean:
	rm -fv *.o b-64-b-tuff core core.*
