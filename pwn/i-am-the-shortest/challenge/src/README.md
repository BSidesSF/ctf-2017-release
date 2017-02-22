It is very important to test this one! In theory, a compiler might
mess up some of my code. This should work:

--
$ make clean all && echo -ne '\x87\xf1\xcd\x80' | ./shortest
rm -f *.o shortest core
gcc -O0 -m32 -Wall -o shortest shortest.c
The address of 'flag' is 0xffa2984c
Send your machine code now! Max length = 5 bytes.

FLAG:c9f053110aa0f2d28ed8978e3b03cb01
,,,
--
