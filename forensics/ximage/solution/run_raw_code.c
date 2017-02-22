#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
  struct stat statbuf;
  if (stat(argv[1], &statbuf) == -1) {
    printf("Usage: %s <code.bin>\n", argv[0]);
    exit(0);
  }

  void * a = mmap(0, statbuf.st_size, PROT_EXEC |PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, -1, 0);
  printf("allocated %d bytes of executable memory at: %p\n", statbuf.st_size, a);

  FILE *file = fopen(argv[1], "rb");
  read(fileno(file), a, statbuf.st_size);

  ((void (*)(void)) a)();
}
