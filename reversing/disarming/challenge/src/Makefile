all: disarming disarming.arm

disarming: disarming.c
	gcc -o disarming disarming.c
	strip disarming

disarming.arm: disarming.c
	arm-linux-gnueabihf-gcc -o disarming.arm disarming.c
	arm-linux-gnueabihf-strip disarming.arm

clean:
	rm disarming disarming.arm
