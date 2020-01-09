```C
#include <stdio.h>
#include <unordered_set>

int main() {
	FILE* res = fopen("res", "r");
	unsigned long long vals[2048];

	for (int i = 0; i < 2048; i++) {
		fscanf(res, "%llu\n", &vals[i]);
	}
	fclose(res);

	unsigned long long curval;
	unsigned long long target;
	unsigned long long desired = 0x7046B5C38157C275;

	int startbyte = 32;
	int endbyte = 126;
	std::unordered_set<unsigned long long> found;
	for (int a = startbyte; a <= endbyte; a++) {
		printf("%d\n", a);
		for (int b = startbyte; b <= endbyte; b++) {
			for (int c = startbyte; c <= endbyte; c++) {
				for (int d = startbyte; d <= endbyte; d++) {
					curval = vals[a] ^ vals[256 + b] ^ vals[256*2 + c] ^ vals[256*3 + d];
					found.insert(curval);
				}
			}
		}
	}

	for (int a = startbyte; a <= endbyte; a++) {
		printf("%d - 2\n", a);
		for (int b = startbyte; b <= endbyte; b++) {
			for (int c = startbyte; c <= endbyte; c++) {
				for (int d = startbyte; d <= endbyte; d++) {
					curval = vals[256*4 + a] ^ vals[256*5 + b] ^ vals[256*6 + c] ^ vals[256*7 + d];
					target = curval ^ desired;
					if (found.find(target) != found.end()) {
						printf("WIN\n");
						printf("%llu\n", curval);
						printf("%llu\n", target);
						printf("%d %d %d %d\n", a, b, c, d);
						return 0;
					}
				}
			}
		}
	}
}
```
