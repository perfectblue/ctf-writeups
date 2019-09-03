#include <stdio.h>
#include <stdint.h>
int main()
{
// stage1
// uint32_t key = 0x6d35bcd;
// uint32_t offset = 0xf0c;

// stage2
// uint32_t key = 0x43451b65;
// uint32_t offset = 0x11d4;

// stage3
// uint32_t key = 0x54aaf64b;
// uint32_t offset = 0x193c;

// stage4
uint32_t key = 0x52976abd;
uint32_t offset = 0x2174;


char buf[0x1000];
FILE* fd = fopen("ebc", "rb");
fseek(fd, offset, SEEK_SET);
uint64_t len;
fread(&len, 8, 1, fd);
if (fread(buf, 1, len, fd) != len)
    perror("fread");
fclose(fd);
printf("Length = 0x%lx\n", len);

for (uint32_t *penis = buf; penis < buf + len; penis++)
{
*penis ^= key;
}

char filename[260];
snprintf(filename, sizeof(filename), "penis_%x.dec.bin", offset);
filename[sizeof(filename)-1] = 0;
fd = fopen(filename, "wb");
fwrite(buf, 1, len, fd);
fclose(fd);

printf("OK\n");
}
