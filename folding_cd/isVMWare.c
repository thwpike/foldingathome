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
