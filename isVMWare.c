/*
 * isVMWare.c - a program to detect the presence of VMWare.
 * Exit code is 1 for no VMWare, 0 for VMWare detected
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
  int rc;
  sigaction(SIGSEGV, &act, NULL);
  asm("movw $0x5658, %%dx\n\t"
      "in %%dx, %%eax":
      "=b" (rc) : "a" (0x564D5868), "b" (0), "c" (10):
      "%dx");

  return (rc != 0x564D5868);
}
