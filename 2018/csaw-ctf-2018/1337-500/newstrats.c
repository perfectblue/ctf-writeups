#include <stdint.h>
#include <stdio.h>

#define u64 uint64_t

u64 stupidpow(u64 x) {
    u64 g = 5;
    u64 bits = x >> 62;
    u64 y = 1;
    int i =0;
    x &= 0x3fffffffffffffff;
    while (x>=2) {
        if (x & 1) { y *= g; 
        }
        x >>= 1;
        g *= g;
        i++;
    }
    return y-1+bits;
}


u64 powm(u64 g, u64 x) {
    u64 y = 1;
    int i = 0;
    while (x) {
        if (x & 1) { y *= g;
        }
        x >>= 1;
        g *= g;
        i++;
    }
    return y;
}


u64 logm(u64 g, u64 x, u64 y, int bit) {
    u64 m = (2ull << bit) - 1;
    u64 f = powm(g, y) ^ x;
    if (!f) return y;
    u64 q;
    if (!(f & m)) {
        if (q = logm(g, x, y, bit + 1)) return q;
    }
    y |= 1ull << bit;
    if (!((powm(g, y) ^ x) & m)) {
        if (q = logm(g, x, y, bit + 1)) return q;
    }
    return 0;
}

u64 stupidlog(u64 x) {
    for (u64 bits = 0; bits < 4; bits++) {
        u64 toLog = x+1-bits;
        u64 result = logm(5, toLog, 0, 0);
        if (result) return result | (bits << 62);
    }
    return 0;
}

int main() {
    printf("%llx\n", stupidlog(0xBEB9E408E58575B0));
    printf("%llx\n", stupidlog(0xB8F8437F04F80044));
    printf("%llx\n", stupidlog(0xC227DF7146B09474));
}
