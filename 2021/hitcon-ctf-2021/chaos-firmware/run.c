#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <sys/mman.h>

struct request {
    unsigned type;
    unsigned in_off;
    unsigned in_size;
    unsigned key_off;
    unsigned key_size;
    unsigned out_off;
    unsigned out_size;
};

int main() {
    struct request req = {0};

    req.in_off = 0;
    req.in_size = 35;
    req.out_off = 4096;
    req.out_size = 4096;

    int fd = open("/dev/chaos", O_RDWR);

    int out = ioctl(fd, 0x4008CA00u, 0xf0000);
    printf("allocate: %d\n", out);

    uint64_t *addr = mmap(0LL, 0xf0000, PROT_READ|PROT_WRITE, 1u, fd, 0LL);
    printf("mmap: %p\n", addr);

    getchar();

    out = ioctl(fd, 0xC01CCA00u, &req);
    printf("request: %d\n", out);

    getchar();

    char* ptr = (char*)addr;

    for (int i = 0; i < 0xf0000; i++) {
        if (ptr[i] != 0) {
            printf("%c", ptr[i]);
        }
    }
}
