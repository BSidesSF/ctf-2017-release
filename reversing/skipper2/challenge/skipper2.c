#include <ctype.h>
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

#define READ 0
#define WRITE 1

static void get_cpuid(char buffer[13])
{
  memset(buffer, 0, 1024);

  int eax = 0; /* Get vendor ID */
  int ebx, ecx, edx;
  /* ecx is often an input as well as an output. */
  asm volatile("cpuid"
      : "=a" (eax),
        "=b" (ebx),
        "=c" (ecx),
        "=d" (edx)
      : "0" (eax), "2" (ecx));

  ((int*)buffer)[0] = ebx;
  ((int*)buffer)[1] = edx;
  ((int*)buffer)[2] = ecx;
  buffer[12] = 0;
}

static void get_name(char *buffer)
{
  int pipe_stdout[2];
  int status;
  int n;

  memset(buffer, 0, 1024);

  pipe(pipe_stdout);

  pid_t pid = fork();

  if(!pid)
  {
    /* Copy the pipes. */
    if(dup2(pipe_stdout[WRITE], STDOUT_FILENO) == -1)
    {
      perror("exec: couldn't duplicate STDOUT handle");
      exit(1);
    }

    /* Execute the new process. */
    execlp("uname", "uname", "-n", (char*) NULL);

    /* If execlp returns, bad stuff happened. */
    printf("exec: execlp failed (%d)", errno);
    exit(1);
  }

  waitpid(pid, &status, 0);
  n = read(pipe_stdout[READ], buffer, 1024);

  buffer[n-1] = '\0';
}

static void get_os(char *buffer)
{
  int i, n, m;

  memset(buffer, 0, 1024);

  FILE *f = fopen("/proc/version", "r");
  n = fread(buffer, 1, 1024, f);
  m = strchr(strchr(buffer, ' ') + 1, ' ') - buffer + 1;

  memmove(buffer, buffer + m, n - m);
  for(i = 0; ; i++)
  {
    if(!isdigit(buffer[i]) && buffer[i] != '.')
    {
      buffer[i] = '\0';
      return;
    }
  }
}

#define SWAP(n,s,i,j) tmp=s[(i)%n];s[(i)%n]=s[(j)%n];s[(j)%n]=tmp;
#define A(n,s,i) SWAP(n,s,i*3, i*11)
#define B(n,s,i) SWAP(n,s,i|12,i<<3)
#define C(n,s,i) SWAP(n,s,i*7, i*17)
#define D(n,s,i) SWAP(n,s,i^3, i*i)

#define E(n,s,i) A(n,s,i+buffer2[0]);B(n,s,i+buffer2[ 8]);C(n,s,i+buffer2[16]);D(n,s,i+buffer2[24])
#define F(n,s,i) B(n,s,i+buffer2[1]);C(n,s,i+buffer2[ 9]);D(n,s,i+buffer2[17]);A(n,s,i+buffer2[25])
#define G(n,s,i) C(n,s,i+buffer2[2]);D(n,s,i+buffer2[10]);A(n,s,i+buffer2[18]);B(n,s,i+buffer2[26])
#define H(n,s,i) D(n,s,i+buffer2[3]);A(n,s,i+buffer2[11]);B(n,s,i+buffer2[19]);C(n,s,i+buffer2[27])
#define I(n,s,i) E(n,s,i+buffer2[4]);F(n,s,i+buffer2[12]);G(n,s,i+buffer2[20]);H(n,s,i+buffer2[28])
#define J(n,s,i) H(n,s,i+buffer2[5]);G(n,s,i+buffer2[13]);F(n,s,i+buffer2[21]);E(n,s,i+buffer2[29])
#define K(n,s,i) F(n,s,i+buffer2[6]);F(n,s,i+buffer2[14]);G(n,s,i+buffer2[22]);G(n,s,i+buffer2[30])
#define L(n,s,i) E(n,s,i+buffer2[7]);E(n,s,i+buffer2[15]);H(n,s,i+buffer2[23]);H(n,s,i+buffer2[31])

static void finish(char *buffer2)
{
  char key[] = "8988317ff468a390eb1d163cd46e7b182d6dbedb3c63290174300fdab69c584f";
  /*char buffer[] = "FLAG:18ee7c71d2794f546ca23e6858de0bc6";*/
  char buffer[] = "\x12\x56\x27\x70\x2c\x07\x5a\x67\x44\x0f\x07\x00\x63\x06\x4a\x3c\x0f\x04\x57\x01\x0d\x55\x65\x05\x34\x0b\x6d\x05\x73\x20\x7a\x06\x57\x04\x54\x24\x03\x31";

  int i, j, k, l;
  int tmp;
  int n = sizeof(key)-1;

  for(i = 0; i < sizeof(key); i++)
    key[i] ^= buffer2[i];

  for(i = 0; i < n*100; i++)
  {
    I(n, key, i);
    J(n, key, i);
    K(n, key, i);
    L(n, key, i);
  }

  for(i = 0; i < sizeof(buffer); i++)
    buffer[i] ^= key[i];

  printf("\n\n");

  printf("The key is: %s\n", buffer);
}

int main(int argc, char **argv)
{
  int  i;
  char buffer[1024];
  char buffer2[1024];

  memset(buffer2, 0, 1024);

  get_name(buffer);
#ifdef TEST1
  strcpy(buffer, "hax0rz!~");
#endif
  printf("Computer name: %s\n", buffer);
  if(strcmp(buffer, "hax0rz!~"))
  {
    printf("Sorry, your computer's name - %s - is not correct!\n", buffer);
    raise(SIGKILL);
  }
  strcat(buffer2, buffer);

  get_os(buffer);
  printf("OS version: %s\n", buffer);

#ifdef TEST2
  strcpy(buffer, "2.4.31");
#endif

  if(strcmp(buffer, "2.4.31"))
  {
    printf("Sorry, your OS version - %s - is not supported!\n", buffer);
    raise(SIGKILL);
  }
  strcat(buffer2, buffer);

  get_cpuid(buffer);
#ifdef TEST3
  strcpy(buffer, "AMDisbetter!");
#endif

  printf("%s\n", buffer);
  if(strcmp(buffer, "AMDisbetter!"))
  {
    printf("Sorry, your CPU - %s - is not supported!\n", buffer);
    raise(SIGKILL);
  }
  strcat(buffer2, buffer);

  finish(buffer2);
}

