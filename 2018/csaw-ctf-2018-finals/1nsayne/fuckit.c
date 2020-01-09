#include <stdio.h>
#include <stdint.h>
uint64_t collatz(unsigned int a1)
{
  unsigned int v2; // [rsp+0h] [rbp-4h]

  v2 = a1;
  while ( v2 != 1 )
  {
    if ( (v2 & 1) == 1 )
      v2 = 3 * v2 + 1;
    else
      v2 >>= 1;
  }
  return 1LL;
}

int main() {
printf("%x\n", collatz(0x636B1C45));
}
