#include <stdio.h>

#define ROUNDS (1 << 22) + 2

unsigned char sbox[256] = {109, 86, 136, 240, 199, 237, 30, 94, 134, 162, 49, 78, 111, 172, 214, 117, 90, 226, 171, 105, 248, 216, 48, 196, 130, 203, 179, 223, 12, 123, 228, 96, 225, 113, 168, 5, 208, 124, 146, 184, 206, 77, 72, 155, 191, 83, 142, 197, 144, 218, 255, 39, 236, 221, 251, 102, 207, 57, 15, 159, 98, 80, 145, 22, 235, 63, 125, 120, 245, 198, 10, 233, 56, 92, 99, 55, 187, 43, 25, 210, 153, 101, 44, 252, 93, 82, 182, 9, 36, 247, 129, 3, 84, 74, 128, 69, 20, 246, 141, 2, 41, 169, 59, 217, 137, 95, 189, 138, 116, 7, 180, 60, 18, 238, 73, 133, 121, 62, 87, 40, 213, 37, 33, 122, 200, 192, 118, 205, 135, 53, 58, 89, 201, 21, 193, 149, 8, 112, 81, 243, 131, 158, 188, 154, 211, 147, 164, 195, 181, 222, 178, 67, 76, 115, 150, 127, 103, 254, 1, 249, 186, 88, 177, 61, 14, 152, 106, 161, 229, 70, 160, 175, 29, 224, 66, 38, 91, 79, 185, 114, 190, 6, 110, 194, 250, 119, 0, 230, 176, 51, 104, 219, 215, 151, 75, 13, 23, 165, 11, 139, 42, 167, 52, 85, 156, 253, 163, 19, 35, 140, 107, 31, 143, 166, 32, 47, 132, 239, 234, 71, 241, 157, 170, 64, 100, 16, 97, 227, 204, 34, 4, 50, 126, 209, 174, 46, 45, 28, 232, 24, 212, 244, 220, 173, 17, 54, 231, 108, 65, 202, 27, 68, 26, 183, 148, 242};

void encrypt1(unsigned char *k, unsigned char *pt, unsigned char *ct) {
    unsigned char a = pt[0], b = pt[1], c = pt[2], d = pt[3], t;
    int i;
    for (i = 0; i < ROUNDS; i++) {
        a ^= sbox[b ^ k[(2*i)&3]];
        c ^= sbox[d ^ k[(2*i+1)&3]];
        t = a; a = b; b = c; c = d; d = t;
    }
    ct[0] = a; ct[1] = b; ct[2] = c; ct[3] = d;
}

void encrypt2(unsigned char *k, unsigned char *pt, unsigned char *ct) {
    unsigned char a = pt[0], b = pt[1], c = pt[2], d = pt[3], t;
    int i;
    for (i = ROUNDS - 1; i >= 0; i--) {
        t = b; b = a; a = d; d = c; c = t;
        c ^= sbox[d ^ k[(2*i)&3]];
        a ^= sbox[b ^ k[(2*i+1)&3]];
    }
    ct[0] = a; ct[1] = b; ct[2] = c; ct[3] = d;
}

int main()
{
    unsigned char k01, k23, k0, k2, st;
    unsigned char k[5] = {0}, pt[5] = {0}, ct[5] = {0}, res[5] = {0};
    scanf("%hhu%hhu%hhu", &k01, &k23, &st);
    scanf("%hhu%hhu%hhu%hhu", &res[0], &res[1], &res[2], &res[3]);

    k0 = st;
    k2 = 0;
    st += 8;
    do {
        do {
            k[0] = k0; k[1] = k0 ^ k01; k[2] = k2; k[3] = k2 ^ k23;
            encrypt1(k, pt, ct);
            if (ct[0] == res[0] && ct[1] == res[1] && ct[2] == res[2] && ct[3] == res[3]) {
                printf("%02x%02x%02x%02x\n", k[0], k[1], k[2], k[3]);
                return 0;
            }
            k2++;
        } while (k2 != 0);
        k0++;
    } while (k0 != st);
    return 1;
}