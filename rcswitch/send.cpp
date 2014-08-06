#include "RCSwitch.h"
#include <stdlib.h>
#include <stdio.h>
#include <iostream>

using namespace std;

int main(int argc, char *argv[]) {
  if (wiringPiSetup() == -1)
    return 1;

  RCSwitch rc = RCSwitch();
  rc.enableTransmit(0);

  fprintf(stdout, "READY\n");
  fflush(stdout);

  char line[1024];
  while (cin.getline(line, 1024)) {
    int code = atoi(line);
    rc.send(code, 24);
  }

  return 0;
}
