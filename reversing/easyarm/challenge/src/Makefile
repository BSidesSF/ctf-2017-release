all: easyarm easyarm.arm

easyarm.c: easyarm.py easyarm.c.in
	python easyarm.py

easyarm: easyarm.c
	gcc -o easyarm easyarm.c
	strip easyarm

easyarm.arm: easyarm.c
	arm-linux-gnueabihf-gcc -o easyarm.arm easyarm.c
	arm-linux-gnueabihf-strip easyarm.arm

clean:
	rm easyarm easyarm.arm
