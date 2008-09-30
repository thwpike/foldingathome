/*
 * queueinfo.c - a program to output the state of the work unit slots
 * Reads from queue.dat in the CWD.
 * Copyright Nicholas Reilly 29 September 2008
 * Licensed under the GPL v2 or any later version
 */
#include <sys/mman.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>

#define SIZE 7168

int main(int argc, char *argv[])
{
  char *addr, *stat;
  int fd, loop;

  fd = open("queue.dat", O_RDONLY);
  if (fd == -1) {
    perror("Failed to open queue.dat");
    return EXIT_FAILURE;
  }

  addr = mmap(NULL, SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
  if (addr == MAP_FAILED) {
    perror("Failed to map file");
    return EXIT_FAILURE;
  }

  /* Skip first 8 bytes (general stuff)*/
  stat = addr + 8;

  for (loop = 0; loop < 10; loop++) {
    /* Status is in next byte */
    printf("%d %d\n", loop, *stat);
    /* Each queue slot is 712 bytes */
    stat += 712;
  }

  (void)munmap(addr, SIZE);
  close(fd);
  return EXIT_SUCCESS;
}
