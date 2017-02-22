#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <stdint.h>

#define disable_buffering(_fd) setvbuf(_fd, NULL, _IONBF, 0)

void get_flag(char *buf)
{
  FILE *f = fopen("/home/ctf/flag.txt", "r");
  if(!f)
  {
    printf("Couldn't open flag.txt file!\n");
    system("pwd");
    exit(0);
  }
  fgets(buf, 128, f);
  fclose(f);
}

int main(int argc, char *argv[])
{
  char flag[128];
  void *buf;
  size_t size;

  alarm(10);

	disable_buffering(stdout);
	disable_buffering(stderr);

  memset(flag, 0, 128);

  buf = mmap(0, 5, PROT_EXEC | PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, -1, 0);

  get_flag(flag);
  asm ( "mov %0, %%esi;" /* Make sure the flag is in 'esi' so it can be easily accessed later */
        "mov %1, %%ebx;" /* Make sure ebx is '1', since it will be the file descriptor later */
      :
      : "g"(flag), "g"(1));

  printf("The address of 'flag' is %p\n", &flag); /* This is supposed to look helpful. */
  printf("Send your machine code now! Max length = 5 bytes.\n\n");

  /* In theory, unless they find a clever way to solve this (which would rock!), they want:
   * eax = 4 (the return from fread() will take care of that)
   * ebx = 1 (already set)
   * ecx = buf (can be set with 'xchg esi, ecx' or 'mov ecx, esi')
   * edx = length (already has a good-enough length in it)
   */

  size = read(0, buf, 5); /* The return value from this will be the 'syscall' number (4) */

  asm("mov %0, %%edx" : :"g"(0xFF)); /* We just need a large-ish value in edx, 0xFF looks less sketchy */

  if(size <= 5) /* The real value they should use is '4' */
  {
    asm("jmp *%0"
        :
        : "g"(buf)
       );
  }
  else
  {
    printf("Sorry, your code is too long! (%zd bytes, max length = 5)\n", size);
  }

  return 0;
}
