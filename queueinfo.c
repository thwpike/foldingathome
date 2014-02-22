/*
 * queueinfo.c - a program to output the state of the work unit slots
 * Reads from queue.dat in argv[1] the state of slot argv[2]
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
  int fd, slot;

  if (argc != 3) {
    fprintf(stderr, "Usage: %s <queue.dat> <slot 0-9>\n", argv[0]);
    return EXIT_FAILURE;
  }
  slot = atoi(argv[2]);
  if ((slot < 0) || (slot > 9)) {
    fprintf(stderr, "Usage: %s <queue.dat> <slot 0-9>\n", argv[0]);
    return EXIT_FAILURE;
  }

  fd = open(argv[1], O_RDONLY);
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

  /* Each queue entry is 712 bytes long with status as first byte */
  stat += (712 * slot);
  printf("%d\n", *stat);

  (void)munmap(addr, SIZE);
  close(fd);
  return EXIT_SUCCESS;
}
