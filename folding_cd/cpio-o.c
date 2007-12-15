/*
 * cpio.c - aprogram to create a cpio archive in newc format
 * File list is read from stdin and archive is output to stdout
 * Copyright Nicholas Reilly 1 Aug 2007
 * Licensed under the GPL v2 or any later version
 */
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <limits.h>
#include <fcntl.h>

static unsigned int bytes_written = 0;

static void do_align() {
    unsigned char pad;
    pad = bytes_written % 4;
    pad = 4 - pad;
    if (pad < 4) {
        while (pad > 0) {
            printf("%c", 0);
            pad --;
            bytes_written++;
        }
    }
}

static void do_trailer() {
    const char filename[] = "TRAILER!!!";

    do_align();

    printf("070701");
    printf("%08X", 0);
    printf("%08X", 0);
    printf("%08X", 0);
    printf("%08X", 0);
    printf("%08X", 1);
    printf("%08X", 0);
    printf("%08X", 0);
    printf("%08X", 0);
    printf("%08X", 0);
    printf("%08X", 0);
    printf("%08X", 0);
    printf("%08X", strlen(filename) + 1);
    printf("%08X", 0);
    bytes_written+=110;
    printf("%s", filename);
    printf("%c", 0);
    bytes_written = bytes_written + strlen(filename) + 1;

    do_align();
}


static void do_file(char *filename) {
    struct stat buf;
    char data[PATH_MAX];
    ssize_t data_size;
    int fd;

    if(lstat(filename, &buf) == -1) {
        fprintf(stderr, "Unable to stat %s, %s\n", filename, strerror(errno));
        return;
    }

    do_align();

    printf("070701");
    printf("%08X", buf.st_ino);
    printf("%08X", buf.st_mode);
    printf("%08X", buf.st_uid);
    printf("%08X", buf.st_gid);
    printf("%08X", buf.st_nlink);
    printf("%08X", buf.st_mtime);
    printf("%08X", S_ISDIR(buf.st_mode)? 0 : buf.st_size);
    printf("%08X", buf.st_dev >> 8);
    printf("%08X", buf.st_dev & 0xff);
    printf("%08X", buf.st_rdev >> 8);
    printf("%08X", buf.st_rdev &0xff);
    printf("%08X", strlen(filename) + 1);
    printf("%08X", 0);
    bytes_written+=110;
    printf("%s", filename);
    printf("%c", 0);
    bytes_written = bytes_written + strlen(filename) + 1;

    do_align();

    /* data */
    if (S_ISLNK(buf.st_mode)) {
        data_size = readlink(filename, data, PATH_MAX);
        if (data_size == -1) {
            fprintf(stderr,"Failed to read link %s, %s\n",
                    filename, strerror(errno));
            return;
        }
        data[data_size] = '\0';
        printf("%s", data);
        bytes_written += data_size;
    } else if (S_ISREG(buf.st_mode)) {
        fflush(stdout);
        fd = open(filename, O_RDONLY);
        if (fd == -1) {
            fprintf(stderr,"Failed to open %s for reading, %s\n",
                    filename, strerror(errno));
            return;
        }
        do {
            data_size = read(fd, data, PATH_MAX);
            write(1, data, data_size);
            bytes_written += data_size;
        } while (data_size > 0);
        close(fd);
    }
}

int main (int argc, char **argv) {
    char filename[255];
    char *new_filename;

    while(fgets(filename, sizeof(filename), stdin)) {
        /* Remove the trailing newline */
        filename[strlen(filename) - 1] = '\0';
        if ((strlen(filename) > 2) && (filename[0] == '.') &&
            (filename[1] == '/')) {
            new_filename = filename + 2;
        } else {
            new_filename = filename;
        }
        do_file(new_filename);
    }
    do_trailer();
    return 0;
}
