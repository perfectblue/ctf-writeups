#include <openssl/sha.h>
#include <string.h>
#include <stdio.h>

int main(int argc, char **argv) {
	const char *pref = argv[1];
	char sol[21];
	sol[20] = 0;
	if (strlen(pref) != 10)
		return 1;
	memcpy(sol, pref, 10);
	memset(sol+10, 'a', 10);

	for (;;) {
		SHA256_CTX c;
		SHA256_Init(&c);
		SHA256_Update(&c, sol, 20);
		unsigned char md[32];
		SHA256_Final(md, &c);

		if (md[31] == 0 && md[30] == 0 && (md[29]&0xf) == 0) {
			puts(sol+10);
			return 0;
		}

		char *it = sol+10;
		while ((*it += 1) > 'z') {
			*it++ = 'a';
		}
	}
}
