#include "RCSwitch.h"
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
  if (wiringPiSetup() == -1)
    return 1;

  RCSwitch rc = RCSwitch();
  rc.enableReceive(2);

  while(1) {
    if (rc.available()) {
      int value = rc.getReceivedValue();
      fprintf(stdout, "%i\n", value);
      fflush(stdout);
      rc.resetAvailable();
    }
  }

  return 0;
}
