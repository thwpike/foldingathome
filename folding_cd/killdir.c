#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>


int main(int argc, char **argv)
{
  DIR *dir;
  struct dirent *entry;
  char *name, link[PATH_MAX], exepath[PATH_MAX], cwdpath[PATH_MAX];
  ssize_t size;

  if (argc != 3) {
    printf("%s <procname> <dir>\n", argv[0]);
    exit(1);
  }

  dir = opendir("/proc");
  if (!dir) {
    perror("Failed to open /proc");
    exit(1);
  }

  while (entry = readdir(dir)) {
    name = entry->d_name;
    if (!(*name >= '0' && *name <= '9')) {
      continue;
    }

    snprintf(link, PATH_MAX, "/proc/%s/exe", name);
    size = readlink(link, exepath, PATH_MAX);
    if (size < 1) {
      continue;
    }

    snprintf(link, PATH_MAX, "/proc/%s/cwd", name);
    size = readlink(link, cwdpath, PATH_MAX);
    if (size < 1) {
      continue;
    }

    if ((strcmp(exepath, argv[1]) == 0) && (strcmp(cwdpath, argv[2]) ==0)) {
      kill(atoi(name),9);
    }

  }

  closedir(dir);
  exit(0);
}
