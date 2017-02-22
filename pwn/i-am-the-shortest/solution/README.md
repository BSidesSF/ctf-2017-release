The idea behind this is to write shellcode in no more than 5 bytes. My solution
actually requires 4 bytes, The trick is that the state of the registers matters
when the code is run. At that point, eax is the length (4), ebx is 1, esi is
a pointer to flag.txt's value, and edx is 0xdd.

That means that eax is already set up to call sys_write (4), ebx is already set
to stdout (1), and edx is already set to a useful length (0xff). That just
leaves one thing before we can use sys_write: setting ecx to flag.txt.

This simple shellcode will take care of that, then call sys_write:
* xchg esi, ecx
* int 0x80

Which compiles to:
87 ce cd 80

So you can own it with:
echo -ne "\x87\xce\xcd\x80" | ./shortest

