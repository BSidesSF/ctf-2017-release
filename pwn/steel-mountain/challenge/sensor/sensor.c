
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdarg.h>
#include "../cgic/cgic.h"
#include "../common.h"

#define MAX_SENSORS 64
float sensor_data[MAX_SENSORS];

#ifdef DEBUG
FILE *dbg;
#endif

__attribute__((constructor))
void loadSensorData() {
  int i;
  float v;
  for (i=0;i<MAX_SENSORS;i++) {
    v = (float)random();
    v *= 10;
    v /= RAND_MAX;
    sensor_data[i] = v + 20;
  }
}

int loadSensorConfig(char *sensorName) {
  char fileName[128], configBuf[256];
  int sensor;
  FILE *fp;

  if (strstr(sensorName, "/..")) {
    cgiHeaderStatus(403, "Forbidden");
    return -1;
  }

  snprintf(fileName, sizeof(fileName), "sensors/%s.cfg", sensorName);

  fileName[strcspn(fileName, "\r\n")] = '\0';

#ifdef DEBUG
  fprintf(dbg, "Opening: %s\n", fileName);
#endif

  fp = fopen(fileName, "r");
  if (!fp) {
    cgiHeaderStatus(404, "Not Found");
    debug_printf("Could not find sensor configuration.");
    return -1;
  }

  if (!fgets(configBuf, sizeof(configBuf), fp)) {
    fclose(fp);
    cgiHeaderStatus(404, "Not Found");
    debug_printf("Could not find sensor configuration.");
    return -1;
  }

  fclose(fp);

  if (sscanf(configBuf, "sensor = %d", &sensor) != 1) {
    cgiHeaderStatus(400, "Bad Request");
    debug_printf("Invalid configuration:\n%s\n", configBuf);
    return -1;
  }

  return sensor;
}

int cgiMain() {
  char sensorName[64];
  int s;

#ifdef DEBUG
  dbg = fopen("/tmp/sensors.log", "a");
  fprintf(dbg, "Working dir: %s\n", getcwd(NULL, 0));
#endif

  if (cgiFormString("sensor", sensorName, sizeof(sensorName)) != cgiFormSuccess) {
    cgiHeaderStatus(400, "Missing sensor.");
    debug_printf("Need sensor.");
    return 1;
  }

  if ((s = loadSensorConfig(sensorName)) < 0) {
    return 1;
  }

  if (s > MAX_SENSORS) {
    cgiHeaderStatus(400, "Bad Request");
    debug_printf("Invalid sensor.");
    return 1;
  }

  cgiCORS();
  cgiHeaderContentType("application/json");
  fprintf(cgiOut, "{\"temp\": %f}", sensor_data[s]);

  return 0;
}
