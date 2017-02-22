#include "common.h"
#include <stdarg.h>

void cgiCORS() {
  fprintf(cgiOut, "Access-Control-Allow-Origin: *\r\n");
}

int debug_printf(char *fmt, ...) {
  int f, rv;
  va_list val;

  if (cgiFormStringSpaceNeeded("debug", &f) != cgiFormSuccess)
    return 0;

  va_start(val, fmt);

  rv = vfprintf(cgiOut, fmt, val);

  va_end(val);

  return rv;
}
