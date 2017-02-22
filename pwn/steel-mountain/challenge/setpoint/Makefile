setpoint.cgi: setpoint.c ../common.c
	gcc -Os -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0 -fno-stack-protector -static -o setpoint.cgi setpoint.c md5.c ../cgic/cgic.c ../common.c
