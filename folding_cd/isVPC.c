/*
 * isVPC.c - a program to detect the presence of VirtualPC.
 * Exit code is 1 for no VirtualPC, 0 for VirtualPC detected
 * Copyright Nicholas Reilly 2007
 * Licensed under the GPL v2 or any later version
 */
#include <stdlib.h>
#include <signal.h>

void handleSignal(int signal) {
  exit(1);
}
  
struct sigaction act = {
  handleSignal,
  0,
  0,
  0
};
	  
int main (int argc, char **argv)
{
  sigaction(SIGILL, &act, NULL);
  asm(".byte 0x0F;"
      ".byte 0x3F;"
      ".byte 0x07;"
      ".byte 0x0B;":
      : "a" (1), "b" (0));
  return 0;
}
