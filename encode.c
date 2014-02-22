/*
 * encode.c - a program to encode the F@H proxy password
 * Config file is read from stdin and encoded to stdout
 * Copyright Nicholas Reilly 22 June 2008
 * Licensed under the GPL v2 or any later version
 */
#include <stdio.h>
#include <string.h>
int main (int argc, char **argv) {
  char line[1024];
  char *orig;
  char *subst;
  unsigned int i;

  while(fgets(line, sizeof(line), stdin)) {
    /* Remove the trailing newline */
    line[strlen(line) - 1] = '\0';
    if(strncmp(line, "proxy_passwd=", 13)) {
      printf("%s\n", line);
    } else {
      orig = line + 13;
      for(i = 0; i < strlen(orig); i++) {
        subst = orig + i;
        *subst += 100;
      }
    printf("proxy_passwd=%s%c\n", orig, 0xae);
    }
  }
  return 0;
}
