#include <stdio.h>

int main() {
  asm("data:\n"
      ".incbin \"build/6d60558594d850e0/config.json\"");
}

