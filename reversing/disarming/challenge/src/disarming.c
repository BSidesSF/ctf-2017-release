#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#define E_S "d2"
#define E_D "d%"
#define SP "a"
#define NL "K"

#define FIB_MAX 256

char *strings[] = {
  "rm -rf /",
  "abcdefghijklmnopqrstuvwxyz",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  "0123456789",
  "libc-2.10.so",
  "rm -rf ${HOME}",
};

FILE *out_stream[] = {
  NULL,
  NULL,
};

unsigned int fibs[FIB_MAX];
unsigned int xlate[FIB_MAX];
int no_flag = 0;
char *code;

int (*local_vfprintf) (FILE *, const char *, va_list) = vfprintf;

__attribute__ ((constructor))
void setup_streams() {
  out_stream[0] = stdout;
  out_stream[1] = stderr;
}

__attribute__ ((constructor))
void setup_fibs() {
  int n = 0;
  fibs[0] = 1;
  fibs[1] = 1;
  for (n = 2; n < FIB_MAX; n++) {
    fibs[n] = fibs[n-1] + fibs[n-2];
  }
  for (n = 0; n < FIB_MAX; n++) {
    xlate[n] = fibs[n] ^ n;
    xlate[n] = xlate[n] & 0x7F;
  }
}

void Exit() {
  _exit(1);
}

int myprintf(int is_stderr, const char *fmt_encoded, ...) {
  va_list ap;
  int i;
  char *buf;
  int *ibuf, *iptr, *bptr, *sptr;
  float rv;

  is_stderr = __builtin_popcount(is_stderr) & 1;
  va_start(ap, fmt_encoded);
  buf = strdup(fmt_encoded);
  ibuf = malloc(strlen(buf));
  iptr = ibuf;
  for (i = (strlen(fmt_encoded) + 3) / 4; i >= 0 ; i--) {
    *iptr = i;
    iptr++;
    bptr = (int *)(&buf[i*4]);
    *bptr ^= 0x41414141;
  }
  buf[strlen(fmt_encoded)] = '\0';
  rv = (float)local_vfprintf(out_stream[is_stderr], buf, ap);
  va_end(ap);
  for (i=0; i<strlen(fmt_encoded);i++)
    buf[i] = (char)0x1ff;
  free(buf);
  free(ibuf);
  return (int)rv;
}

__attribute__ ((flatten))
int main(int argc, char **argv) {
  char buf[1024];
  int val;
  int i;
  unsigned long long ull;
  char *p;

  printf("To disarm, you need a secret code and some validators!\n");
  myprintf(0, "\x11-$ 2$a$/5$3ad2ad2{a", "secret", "code");
  fgets(buf, sizeof(buf)-33, stdin);
  code = strdup(buf);
  for(p=code;*p;p++)
    if (*p == '\n')
      *p = '\0';
  myprintf(0, "\x11-$ 2$a$/5$3ad2ad2{a", "first", "validator");
  fgets(buf, sizeof(buf)-32, stdin);
  val = strtol(buf, NULL, strlen(code));
  for (i = 0;i < strlen(code);i++) {
    val -= fibs[code[i]];
  }
  // 0x803ef13a
  no_flag = no_flag | val;

  //!'rv
  no_flag = no_flag | (xlate[code[0]] ^ 'F');
  no_flag = no_flag | (xlate[code[1]] ^ 'l');
  no_flag = no_flag | (xlate[code[2]] ^ 'g');
  no_flag = no_flag | (xlate[code[3]] ^ 'G');

  i = no_flag ? 8 : strlen(code);
  i -= 4;

  buf[i] = 0;

  for (; i != -1 ; i--){
    buf[i] = xlate[code[i+4]];
  }

  ull = strtoull(buf, NULL, no_flag ? 8 : strlen(code));

  //2<PNBttBNP<2
  no_flag |= (ull ^ 0x052376673250LL);

  if (no_flag) {
    printf("Sorry, no flag for you!");
    Exit();
    myprintf(4, "\x18$ )ma25(--a/.a'- &a'.3a8.4oKKKKK");
  }
}

__attribute__ ((destructor))
void destroy(){
  if (no_flag)
    return;
  myprintf(0, "\x06..%a$/.4&){a");
  while(*code) {
    myprintf(0, "d\"", xlate[*code]);
    code++;
  }
  myprintf(0, NL, 1);
}
