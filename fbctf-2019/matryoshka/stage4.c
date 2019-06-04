// compile me with -O3
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>

#define PARALLEL 8

int main(){
  unsigned char desired[4] = {231, 112, 90, 192}; // desired keystream
  unsigned char key[8];
  *(uint32_t*)&key[4] = 0x36395477;

  uint64_t rolling_val = 0x0706050403020100;
  unsigned char initial[256];
  for (int i = 0; i < 256; i++)
    initial[i] = i;
  unsigned char S[256];

  // parallelism shit
  unsigned int brute = 0;
  uint64_t upto = (0x100000000L / (uint64_t)PARALLEL);
  int worker = 0;
  for (;worker < PARALLEL; worker++) {
      if (!fork()) {
          printf("worker %d, %x to %lx\n", worker,brute,upto);
          break; // child
      }
      brute = upto;
      upto += (0x100000000L / (uint64_t)PARALLEL);
  }
  uint32_t start = brute;

  do {
    if ((brute & 0xffffff) == 0) printf("%08x, %.02f%% done\n", brute, 100.f*(brute-start)/(float)(upto-start));
    memcpy(S, initial, 256);
    *(uint32_t*)key = brute;

    unsigned char j = 0;
    for (int i = 0; i < 256; i++){
      j = (j + S[i] + key[i % 8]);
      unsigned char tmp = S[i];
      S[i] = S[j];
      S[j] = tmp;
    }
    unsigned char i =0;
    j = 0;
    for (int n = 0; n < 4; n++) {
      i = (i + 1);
      j = (j + S[i]);
      unsigned char tmp = S[i];
      S[i] = S[j];
      S[j] = tmp;
      if (S[(S[i] + S[j]) & 0xff] != desired[n]) goto fail;
    }

    //gucci
    unsigned char cipher[8] = {0xF6,0x2C,0x72,0x1A,0x03,0x99,0x0E,0x78};
    printf("FOUND IT!!!!!!! %08x\n", brute);
    for (int n = 0; n < 4; n++) {
      i = (i + 1);
      j = (j + S[i]);
      unsigned char tmp = S[i];
      S[i] = S[j];
      S[j] = tmp;
      printf("%02x ", (uint8_t)S[(S[i] + S[j])&0xff]^cipher[n+4]);
    }printf("\n");
    int fd = open("sice.txt", O_APPEND | O_RDWR | O_CREAT,0);
    dprintf(fd, "FOUND IT!!!!!!! %08x\n", brute);
    close(fd);
    kill(0,SIGQUIT);
    break;

    fail:
    brute++;
    // super ghetto ascii-only brute
    if ((brute & 0xff) < 0x20) brute += 0x20-(brute&0xff);
    if ((brute & 0xffff) < 0x2000) brute += 0x2000-(brute&0xffff);
    if ((brute & 0xffffff) < 0x200000) brute += 0x200000-(brute&0xffffff);
    if ((brute & 0xffffffff) < 0x20000000) brute += 0x20000000-(brute&0xffffffff);
    if ((brute & 0xff) >= 0x7f) brute += 0x100-(brute&0xff);
    if ((brute & 0xffff) >= 0x7f00) brute += 0x10000-(brute&0xffff);
    if ((brute & 0xffffff) >= 0x7f0000) brute += 0x1000000-(brute&0xffffff);
    if ((brute & 0xffffffff) >= 0x7f000000) break;
  } while(brute < upto);
}
