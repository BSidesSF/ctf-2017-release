#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <openssl/md5.h>
#include <sys/mman.h>

#define LENGTH 1024
#define disable_buffering(_fd) setvbuf(_fd, NULL, _IONBF, 0)

int verify(uint8_t *hash, uint8_t *data, size_t length) {
  uint8_t buffer[MD5_DIGEST_LENGTH];
  MD5_CTX ctx;
  MD5_Init(&ctx);
  MD5_Update(&ctx, data, length);
  MD5_Final(buffer, &ctx);

  return !memcmp(buffer, hash, MD5_DIGEST_LENGTH);
}

int main(int argc, char *argv[])
{
  uint8_t *buffer = mmap(NULL, LENGTH, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
  ssize_t len;

  alarm(10);

  disable_buffering(stdout);
  disable_buffering(stderr);

  printf("Send me stuff!!\n");
  len = read(0, buffer, LENGTH);

  if(len < 0) {
    printf("Error reading!\n");
    exit(1);
  }

  if(len < 16) {
    printf("Message was too short!\n");
    printf("Expected: <md5sum><code>\n");
    exit(1);
  }

  if(!verify(buffer, buffer+16, len - 16)) {
    printf("md5sum didn't check out!\n");
    printf("Expected: <md5sum><code>\n");
    exit(1);
  }

  asm("call *%0\n" : :"r"(buffer));

  return 0;
}
