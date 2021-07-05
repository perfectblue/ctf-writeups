#include <stdio.h>

char outputs[8010] = {0};
char key[70] = {0};

char NFSR[48] = {0};
char LFSR[16] = {0};

char clock() {
    char t[5] = {LFSR[2], LFSR[4], LFSR[7], LFSR[15], NFSR[27]};
    char *x = t;
    char h = x[1] ^ x[3] ^ (x[0] & x[3]) ^ (x[0] & x[1] & x[2]) ^ (x[0] & x[2] & x[3]) ^ (x[0] & x[2] & x[4]) ^ (x[0] & x[1] & x[2] & x[4]);
    char f = NFSR[0] ^ h;

    x = NFSR;
    char g = x[2] ^ x[5] ^ x[9] ^ x[15] ^ x[22] ^ x[26] ^ x[39] ^ (x[26] & x[30]) ^ (x[5] & x[9]) ^ (x[15] & x[22] & x[26]) ^ (x[15] & x[22] & x[39]) ^ (x[9] & x[22] & x[26] & x[39]);
    char nv = LFSR[0] ^ g;

    for (int i = 0; i < 47; i++)
        NFSR[i] = NFSR[i + 1];
    NFSR[47] = nv;

    nv = LFSR[0] ^ LFSR[1] ^ LFSR[12] ^ LFSR[15];
    for (int i = 0; i < 15; i++)
        LFSR[i] = LFSR[i + 1];
    LFSR[15] = nv;

    return f;
}

char lfsr_clock() {
    char x[4] = {LFSR[2], LFSR[4], LFSR[7], LFSR[15]};
    char t1 = x[1] ^ x[3] ^ (x[0] & x[3]) ^ (x[0] & x[1] & x[2]) ^ (x[0] & x[2] & x[3]);
    char t2 = (x[0] & x[2]) ^ (x[0] & x[1] & x[2]);

    char nv = LFSR[0] ^ LFSR[1] ^ LFSR[12] ^ LFSR[15];
    for (int i = 0; i < 15; i++)
        LFSR[i] = LFSR[i + 1];
    LFSR[15] = nv;

    if (t2)
        return -1;
    else
        return t1;
}

void backtrack(int idx) {
    if (idx == 48) {
        int i;
        for (i = 0; i < 48; i++)
            NFSR[i] = key[i];
        for (i = 0; i < 16; i++)
            LFSR[i] = key[i + 48];
        
        for (i = 0; i < 4000; i++) {
            if (clock() != outputs[i] - '0') {
                return;
            }
        }

        for (i = 0; i < 64; i++)
            printf("%d", key[i]);
        printf("\n");
        return;
    }
    if (key[idx] == -1) {
        key[idx] = 1;
        backtrack(idx + 1);
        key[idx] = 0;
        backtrack(idx + 1);
        key[idx] = -1;
        return;
    }
    backtrack(idx + 1);
}

void backtrack_lfsr(int idx) {
    if (idx == 16) {
        int i;
        for (i = 0; i < 16; i++) {
            // printf("%d", key[48 + i]);
            LFSR[i] = key[48 + i];
        }
        // printf("\n");

        for (i = 0; i < 48; i++) {
            char t = lfsr_clock();
            if (t == -1) {
                key[i] = -1;
            }
            else {
                key[i] = (outputs[i] - '0') ^ t;
            }
        }

        backtrack(0);
        return;
    }

    key[48 + idx] = 0;
    backtrack_lfsr(idx + 1);
    key[48 + idx] = 1;
    backtrack_lfsr(idx + 1);
}


int main()
{
    scanf("%s", outputs);
    backtrack_lfsr(0);
    return 0;
}