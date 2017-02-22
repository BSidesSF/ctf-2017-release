CFLAGS?=-Wall -fno-stack-protector -m32
LIBS?=-lpthread -lm
all: nibbler

clean:
	rm -f nibbler *.o core core.*

nibbler: nibbler.o
	${CC} ${CFLAGS} -o nibbler nibbler.o ${LIBS}
