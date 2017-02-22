#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#define LENGTH 4096
#define MAX_ENCODED_LENGTH (4 * ((LENGTH + 2) / 3))

static char encoding_table[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'};
static int mod_table[] = {0, 2, 1};

/* disables IO buffering on the file descriptor */
#define disable_buffering(_fd) setvbuf(_fd, NULL, _IONBF, 0)

static uint8_t *base64_encode(const unsigned char *data, size_t input_length, uint8_t *encoded_data) {

    int i;
    int j;

    size_t output_length = 4 * ((input_length + 2) / 3);

    memset(encoded_data, '\0', output_length);

    if (encoded_data == NULL) return NULL;

    for (i = 0, j = 0; i < input_length; ) {

        uint32_t octet_a = i < input_length ? (unsigned char)data[i++] : 0;
        uint32_t octet_b = i < input_length ? (unsigned char)data[i++] : 0;
        uint32_t octet_c = i < input_length ? (unsigned char)data[i++] : 0;

        uint32_t triple = (octet_a << 0x10) + (octet_b << 0x08) + octet_c;

        encoded_data[j++] = encoding_table[(triple >> 3 * 6) & 0x3F];
        encoded_data[j++] = encoding_table[(triple >> 2 * 6) & 0x3F];
        encoded_data[j++] = encoding_table[(triple >> 1 * 6) & 0x3F];
        encoded_data[j++] = encoding_table[(triple >> 0 * 6) & 0x3F];
    }

    for (i = 0; i < mod_table[input_length % 3]; i++)
        encoded_data[output_length - 1 - i] = '=';

    return encoded_data;
}

int main(int argc, char *argv[])
{
  uint8_t *data;
  ssize_t len;
  uint8_t *encoded;
  size_t  out_len;
  uint8_t *encoded_data;

  alarm(10);

  disable_buffering(stdout);
  disable_buffering(stderr);

  encoded_data = mmap((void*)0x41410000, MAX_ENCODED_LENGTH, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
  printf("Address of buffer start: %p\n", encoded_data);

  data = malloc(LENGTH);
  len = read(0, data, LENGTH);

  if(len < 0) {
    printf("Error reading!\n");
    exit(1);
  }

  printf("Read %zd bytes!\n", len);

  encoded = base64_encode(data, len, encoded_data);
  printf("%s\n", encoded);

  asm("call *%0\n" : :"r"(encoded_data));

  return 0;
}
