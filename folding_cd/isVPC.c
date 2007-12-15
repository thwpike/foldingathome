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
