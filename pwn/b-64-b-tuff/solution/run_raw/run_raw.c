#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#define LENGTH 4096

int main(int argc, char *argv[])
{
  uint8_t *data;

  /* TODO: I might get rid of the base address when I figure out how to set the MSB. */
  data = mmap((void*)0x41410000, LENGTH, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
  read(0, data, LENGTH);

  asm("call *%0\n" : :"r"(data));

  return 0;
}
