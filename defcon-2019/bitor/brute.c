// gcc -march=native -O3 test.c -lcrypto
// FOUND IT!!!!!!! 6043273c
// 7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <wmmintrin.h>
#include <xmmintrin.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>
//compile using gcc and following arguments: -g;-O0;-Wall;-msse2;-msse;-march=native;-maes
#define DO_ENC_BLOCK(m,k) \
    do{\
        m = _mm_xor_si128       (m, k[ 0]); \
        m = _mm_aesenc_si128    (m, k[ 1]); \
        m = _mm_aesenc_si128    (m, k[ 2]); \
        m = _mm_aesenc_si128    (m, k[ 3]); \
        m = _mm_aesenc_si128    (m, k[ 4]); \
        m = _mm_aesenc_si128    (m, k[ 5]); \
        m = _mm_aesenc_si128    (m, k[ 6]); \
        m = _mm_aesenc_si128    (m, k[ 7]); \
        m = _mm_aesenc_si128    (m, k[ 8]); \
        m = _mm_aesenc_si128    (m, k[ 9]); \
        m = _mm_aesenclast_si128(m, k[10]);\
    }while(0)

#define DO_DEC_BLOCK(m,k) \
    do{\
        m = _mm_xor_si128       (m, k[10+0]); \
        m = _mm_aesdec_si128    (m, k[10+1]); \
        m = _mm_aesdec_si128    (m, k[10+2]); \
        m = _mm_aesdec_si128    (m, k[10+3]); \
        m = _mm_aesdec_si128    (m, k[10+4]); \
        m = _mm_aesdec_si128    (m, k[10+5]); \
        m = _mm_aesdec_si128    (m, k[10+6]); \
        m = _mm_aesdec_si128    (m, k[10+7]); \
        m = _mm_aesdec_si128    (m, k[10+8]); \
        m = _mm_aesdec_si128    (m, k[10+9]); \
        m = _mm_aesdeclast_si128(m, k[0]);\
    }while(0)

#define AES_128_key_exp(k, rcon) aes_128_key_expansion(k, _mm_aeskeygenassist_si128(k, rcon))

static __m128i key_schedule[20];//the expanded key

static __m128i aes_128_key_expansion(__m128i key, __m128i keygened){
    keygened = _mm_shuffle_epi32(keygened, _MM_SHUFFLE(3,3,3,3));
    key = _mm_xor_si128(key, _mm_slli_si128(key, 4));
    key = _mm_xor_si128(key, _mm_slli_si128(key, 4));
    key = _mm_xor_si128(key, _mm_slli_si128(key, 4));
    return _mm_xor_si128(key, keygened);
}

//public API
void aes128_load_key(int8_t *enc_key){
    key_schedule[0] = _mm_load_si128((const __m128i*) enc_key);
    key_schedule[1]  = AES_128_key_exp(key_schedule[0], 0x01);
    key_schedule[2]  = AES_128_key_exp(key_schedule[1], 0x02);
    key_schedule[3]  = AES_128_key_exp(key_schedule[2], 0x04);
    key_schedule[4]  = AES_128_key_exp(key_schedule[3], 0x08);
    key_schedule[5]  = AES_128_key_exp(key_schedule[4], 0x10);
    key_schedule[6]  = AES_128_key_exp(key_schedule[5], 0x20);
    key_schedule[7]  = AES_128_key_exp(key_schedule[6], 0x40);
    key_schedule[8]  = AES_128_key_exp(key_schedule[7], 0x80);
    key_schedule[9]  = AES_128_key_exp(key_schedule[8], 0x1B);
    key_schedule[10] = AES_128_key_exp(key_schedule[9], 0x36);

    // generate decryption keys in reverse order.
    // k[10] is shared by last encryption and first decryption rounds
    // k[0] is shared by first encryption round and last decryption round (and is the original user key)
    // For some implementation reasons, decryption key schedule is NOT the encryption key schedule in reverse order
    key_schedule[11] = _mm_aesimc_si128(key_schedule[9]);
    key_schedule[12] = _mm_aesimc_si128(key_schedule[8]);
    key_schedule[13] = _mm_aesimc_si128(key_schedule[7]);
    key_schedule[14] = _mm_aesimc_si128(key_schedule[6]);
    key_schedule[15] = _mm_aesimc_si128(key_schedule[5]);
    key_schedule[16] = _mm_aesimc_si128(key_schedule[4]);
    key_schedule[17] = _mm_aesimc_si128(key_schedule[3]);
    key_schedule[18] = _mm_aesimc_si128(key_schedule[2]);
    key_schedule[19] = _mm_aesimc_si128(key_schedule[1]);
}

void aes128_enc(int8_t *plainText,int8_t *cipherText){
    __m128i m = _mm_load_si128((__m128i *) plainText);

    DO_ENC_BLOCK(m,key_schedule);

    _mm_storeu_si128((__m128i *) cipherText, m);
}

__m128i aes128_dec(__m128i m){
    DO_DEC_BLOCK(m,key_schedule);
    return m;
}

#include <openssl/md5.h>


// 2nd to last block
__attribute__ ((aligned(16))) unsigned char lastiv[16] = {
    0x7C,0xD5,0xE0,0xDD,0x5D,0x69,0x47,0xEF,0xA3,0xBE,0x28,0xD2,0xD8,0x42,0xF2,0x07,
};

// last block
__attribute__ ((aligned(16))) unsigned char lastblock[16] = {
    0xA0,0x62,0x04,0x26,0x4E,0xA0,0x21,0xA9,0x18,0x4F,0xFF,0xAD,0x24,0x81,0x84,0x73,
};

__attribute__ ((aligned(16))) unsigned char firstiv[16] = {
    19, 55, 19, 55, 19, 55, 19, 55, 19, 55, 19, 55, 19, 55, 19, 55
};

__attribute__ ((aligned(16))) unsigned char firstblock[16] = {
    0x95, 0x40, 0x92, 0xE1, 0x67, 0x89, 0xAC, 0xB2, 0xEA, 0x6E, 0x53, 0xCA,
    0x14, 0x6C, 0x4B, 0xFB
};



__attribute__ ((aligned(16))) unsigned char key[16];
__attribute__ ((aligned(16))) unsigned char plain[16];

#define PARALLEL 48

int main(void)
{
    __m128i _lastiv = _mm_load_si128(lastiv);
    __m128i _lastblock = _mm_load_si128(lastblock);
    __m128i _firstiv = _mm_load_si128(firstiv);
    __m128i _firstblock = _mm_load_si128(firstblock);


    unsigned int brute = 0;
    unsigned int upto = (int)(0x100000000L / (uint64_t)PARALLEL);

    int worker = 0;
    for (;worker < PARALLEL; worker++) {
        if (!fork()) {
            printf("worker %d, %x to %x\n", worker,brute,upto);
            break; // child
        }
        brute = upto;
        upto += (int)(0x100000000L / (uint64_t)PARALLEL);
    }

    do {
        // if (!(brute & 0xfffff)) printf("%x\n",brute);
        MD5((unsigned char*)&brute, 4, key);
        aes128_load_key(key);
        _mm_store_si128(plain, _mm_xor_si128(aes128_dec(_lastblock), _lastiv));

        // check padding
        unsigned char last = plain[15];
        if (last < 1 || last > 16) goto bad;
        for (int i = 0; i < last; i++) {
            if (plain[15-i] != last) {
                goto bad;
            }
        }

        // check dex header key already loaded
        _mm_store_si128(plain, _mm_xor_si128(aes128_dec(_firstblock), _firstiv));
        //if (*(int*)plain != 0xA786564 && *(int*)plain != 0x04034b50 && *(int*)plain != 0x464C457F) goto bad; // 'dex\n' and 'pk\x03\x04'
        if (*(int*)plain != 0x464C457F) goto bad; // 7FELF

        // gucci
        printf("FOUND IT!!!!!!! %08x\n", brute);
        int fd = open("sice.txt", O_APPEND | O_RDWR | O_CREAT,0);
        dprintf(fd, "FOUND IT!!!!!!! %08x\n", brute);
        for (int i = 0; i < 16; i++) {
            printf("%02x ", plain[i]);
            dprintf(fd, "%02x ", plain[i]);
        }
        printf("\n");
        dprintf(fd, "\n");
        close(fd);
        kill(0,SIGQUIT);
        break;

        bad:continue;
    } while(++brute != upto);
    printf("worker %d done\n", worker);
}
