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

//#define TEST1
//#define TEST2
//#define TEST3

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

#define E(n,s,i) A(n,s,i);B(n,s,i);C(n,s,i);D(n,s,i)
#define F(n,s,i) B(n,s,i);C(n,s,i);D(n,s,i);A(n,s,i)
#define G(n,s,i) C(n,s,i);D(n,s,i);A(n,s,i);B(n,s,i)
#define H(n,s,i) D(n,s,i);A(n,s,i);B(n,s,i);C(n,s,i)

#define I(n,s,i) E(n,s,i);F(n,s,i);G(n,s,i);H(n,s,i)
#define J(n,s,i) H(n,s,i);G(n,s,i);F(n,s,i);E(n,s,i)
#define K(n,s,i) F(n,s,i);F(n,s,i);G(n,s,i);G(n,s,i)
#define L(n,s,i) E(n,s,i);E(n,s,i);H(n,s,i);H(n,s,i)

static void finish()
{
  char key[] = "8774b4d9c745a4148c55948f5b366f3790de50b8";
  char buffer[] = "\x70\x75\x76\x73\x5f\x53\x04\x08\x57\x54\x0d\x07\x0e\x57\x54\x57\x0c\x01\x56\x0d\x04\x50\x02\x06\x00\x03\x0a\x57\x5f\x5f\x0d\x0a\x59\x5c\x0f\x04\x5e\x30";
  int i, j, k, l;
  int tmp;
  int n = sizeof(key)-1;

  for(i = 0; i < n*100; i++)
  {
    I(n, key, i);
    J(n, key, i);
    K(n, key, i);
    L(n, key, i);
  }

  for(i = 0; i < sizeof(buffer); i++)
    buffer[i] = buffer[i] ^ key[i];

#if 0
  printf("Key in hex: ");
  for(i = 0; i < sizeof(buffer); i++)
    printf("\\x%02x", buffer[i]);
  printf("\n");
#endif

  printf("Result: %s\n", buffer);
}

int main(int argc, char **argv)
{
  char buffer[1024];

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


  get_os(buffer);
  printf("OS version: %s\n", buffer);

#ifdef TEST2
  strcpy(buffer, "2.4.31");
#endif

  if(strcmp(buffer, "2.4.31"))
  {
    printf("Sorry, your OS version - %s - is not supported!\n", buffer);
    buffer[0] = buffer[0]/((buffer[1]/buffer[1])-1);
  }

  get_cpuid(buffer);
#ifdef TEST3
  strcpy(buffer, "AMDisbetter!");
#endif

  printf("%s\n", buffer);
  if(strcmp(buffer, "AMDisbetter!"))
  {
    printf("Sorry, your CPU - %s - is not supported!\n", buffer);
    asm("mov $1,%eax; xorl %ebx,%ebx; int  $0x80");
  }
  else
  {
    finish();
  }
}

