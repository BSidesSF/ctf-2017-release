#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
  char buffer[256];

  printf("What is the password?\n");
  gets(buffer);

  if(!strcmp(buffer, "the password"))
  {
    printf("FLAG:db2f62a36a018bce28e46d976e3f9864\n");
  }
  else
  {
    printf("Wrong!!\n");
  }

  return 0;
}
