
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#include "../cgic/cgic.h"
#include "../common.h"
#include "md5.h"

#define DIGEST "1337f4c3f33d13371337f4c3f33d1337"

float set_point = 25.0;
char USER_AGENT[64];

int cgiMainGet() {
  cgiCORS();
  cgiHeaderContentType("application/json");
  fprintf(cgiOut, "{\"setpoint\": %f}", set_point);
  return 0;
}

int cgiHexTable[256];

__attribute__((constructor))
void initCgiHexTable() {
  cgiHexTable['0'] = 0x0;
  cgiHexTable['1'] = 0x1;
  cgiHexTable['2'] = 0x2;
  cgiHexTable['3'] = 0x3;
  cgiHexTable['4'] = 0x4;
  cgiHexTable['5'] = 0x5;
  cgiHexTable['6'] = 0x6;
  cgiHexTable['7'] = 0x7;
  cgiHexTable['8'] = 0x8;
  cgiHexTable['9'] = 0x9;
  cgiHexTable['a'] = 0xa;
  cgiHexTable['b'] = 0xb;
  cgiHexTable['c'] = 0xc;
  cgiHexTable['d'] = 0xd;
  cgiHexTable['e'] = 0xe;
  cgiHexTable['f'] = 0xf;
}

int verifyCreds(char *username, char *password) {
  char buffer[256] = {0};
  char digest[16];
  char hexdigest[32];
  char *ptr, *s, *d;
  MD5_CTX ctx;
  int i;

  MD5_Init(&ctx);

  strncat(buffer, username, sizeof(buffer));
  strncat(buffer, ":", sizeof(buffer));
  strncat(buffer, password, sizeof(buffer));

  s = buffer;
  d = buffer;
  while (*s) {
    if (*s == '%') {
      *d = (char)((cgiHexTable[*(++s)] << 4) | (cgiHexTable[*(++s)]));
    } else {
      *d = *s;
    }
    ++s;
    ++d;
  }
  *d = '\0';

  MD5_Update(&ctx, (void *)buffer, strlen(buffer));
  MD5_Final(digest, &ctx);

  ptr = hexdigest;
  for (i = 0; i < sizeof(digest); i++)
    ptr += sprintf(ptr, "%02x", digest[i]);

  return (!strcmp(DIGEST, hexdigest));
}

int badRequest(char *msg) {
  cgiHeaderStatus(400, "Bad Request");
  if (msg)
    debug_printf("%s\n", msg);
  return 1;
}

int cgiMainPost() {
  char *username;
  char *password;
  double new_set_point;
  int len;
  cgiFormResultType rv;

  strncpy(USER_AGENT, cgiUserAgent, sizeof(USER_AGENT));

  if (cgiFormStringSpaceNeeded("username", &len) != cgiFormSuccess)
    return badRequest("Username is required.");
  username = malloc(len);
  if (cgiFormString("username", username, len) != cgiFormSuccess)
    return badRequest("Username is required.");


  if (cgiFormStringSpaceNeeded("password", &len) != cgiFormSuccess)
    return badRequest("password is required.");
  password = malloc(len);
  if (cgiFormString("password", password, len) != cgiFormSuccess)
    return badRequest("password is required.");

  if (!verifyCreds(username, password)) {
    cgiHeaderStatus(403, "Forbidden");
    return 1;
  }

  rv = cgiFormDoubleBounded("setpoint", &new_set_point, 0.0, 40.0, 20.0);
  switch (rv) {
    case cgiFormBadType:
    case cgiFormNotFound:
      return badRequest("setpoint is required.");
  }

  set_point = (float)new_set_point;
  
  return cgiMainGet();
}

int cgiMain() {
  if (!strcasecmp(cgiRequestMethod, "post")) {
    return cgiMainPost();
  }
  return cgiMainGet();
}

