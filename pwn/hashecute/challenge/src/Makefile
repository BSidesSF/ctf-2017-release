CC?=gcc
LIBS?=-lssl -lcrypto
OBJS=hashecute.o

hashecute: ${OBJS}
	${CC} ${CFLAGS} -o hashecute ${OBJS} ${LIBS}

clean:
	rm -fv *.o hashecute core core.*
