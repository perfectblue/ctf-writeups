```C
#include <iostream>
#include <cstdlib>
#include <cstdlib>
#include <fstream>
#include <vector>
#include <string.h>

struct condition {
	int offset;
	unsigned long long byteval;
	unsigned long long xorval;
	unsigned long long andval;
	int bytenum;
};

struct xors {
	int destoff;
	int xoroff;
};

std::vector<xors*> xs(357);
std::vector<condition*> conditions(11572);

unsigned long long calculate(unsigned long long inp, int num) {
	condition* temp;
	unsigned long long stack[260] = {0};
	for (int i = 0; i < 11572; i++) {
		temp = conditions[i];
		if (temp->bytenum != num) {
			continue;
		}

		if ((temp->andval & inp) == temp->byteval) {
			stack[temp->offset] ^= temp->xorval;
		}
	}

	xors* temp2;
	for (int i = 0; i < 357; i++) {
		temp2 = xs[i];
		stack[temp2->destoff] ^= stack[temp2->xoroff];
	}

	return stack[80];
}


unsigned long long calculate1(unsigned long long inp) {
	condition* temp;
	unsigned long long stack[260] = {0};
	for (int i = 0; i < 11572; i++) {
		temp = conditions[i];
		if (temp->bytenum >= 4) {
			continue;
		}

		if ((temp->andval & inp) == temp->byteval) {
			stack[temp->offset] ^= temp->xorval;
		}
	}

	xors* temp2;
	for (int i = 0; i < 357; i++) {
		temp2 = xs[i];
		stack[temp2->destoff] ^= stack[temp2->xoroff];
	}

	return stack[80];
}

unsigned long long calculate2(unsigned long long inp) {
	condition* temp;
	unsigned long long stack[260] = {0};
	for (int i = 0; i < 11572; i++) {
		temp = conditions[i];
		if (temp->bytenum < 4) {
			continue;
		}

		if ((temp->andval & inp) == temp->byteval) {
			stack[temp->offset] ^= temp->xorval;
		}
	}

	xors* temp2;
	for (int i = 0; i < 357; i++) {
		temp2 = xs[i];
		stack[temp2->destoff] ^= stack[temp2->xoroff];
	}

	return stack[80];
}

unsigned long long calculate3(unsigned long long inp) {
	condition* temp;
	unsigned long long stack[260] = {0};
	stack[259] = inp;
	for (int i = 0; i < 11572; i++) {
		temp = conditions[i];

		//std::cout << temp->andval << " " << (temp->andval & inp) << " " << temp->byteval << std::endl;
		if ((temp->andval & inp) == temp->byteval) {
			stack[temp->offset] ^= temp->xorval;
		}
	}

	xors* temp2;
	for (int i = 0; i < 357; i++) {
		temp2 = xs[i];
		stack[temp2->destoff] ^= stack[temp2->xoroff];
	}


	return stack[80];
}

int main() {
	FILE* conds = fopen("cond", "r");

	for (int i = 0; i < 11572; i++) {
		conditions[i] = (condition*)malloc(sizeof(struct condition));
		fscanf(conds, "%d %llu %llu %llu %d\n", &conditions[i]->offset, &conditions[i]->byteval, &conditions[i]->xorval, &conditions[i]->andval, &conditions[i]->bytenum);
		//std::cout << conditions[i]->offset << conditions[i]->andval << std::endl;
	}
	fclose(conds);

	FILE* x = fopen("xors", "r");
	for (int i = 0; i < 357; i++) {
		xs[i] = (xors*)malloc(sizeof(xors));
		fscanf(x, "%d %d\n", &xs[i]->destoff, &xs[i]->xoroff);
	}
	fclose(x);

	FILE* out = fopen("res", "w");
	for (int bytenum = 0; bytenum < 8; bytenum++) {
		printf("%d\n", bytenum);
		unsigned long long res;
		unsigned long long pass;
		for (int byteval = 0; byteval <= 0xff; byteval++) { 
			pass = (unsigned long long)byteval << (bytenum*8);
			res = calculate(pass, bytenum);
			fprintf(out, "%llu\n", res);
		}
	}
	fclose(out);

	return 0;

}
 ```
