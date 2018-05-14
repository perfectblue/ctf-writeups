#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char numbers[20][10] = {
    "zero", "one", "two", "three", "four", "five",
    "six", "seven", "eight", "nine", "ten", "eleven", "twelve",
    "thirteen", "fourteen", "fifteen", "sixteen", "seventeen",
    "eighteen", "nineteen"
};
int correct = 0;
int main() {
    char number[10], c;
    greeter();
    initialize();
    for (c = 0; c < 10; c++) {
        printf("%s ", numbers[rand() % 20]);
    }
    printf("\n");
    return 0;
}

void greeter() {
    char name[80];
    strcpy(name, "SomebodyOnceToldMeTheWorldWasGonnaRollMeIAin'tTheSharpestToolInTheShed.." "haha");
    printf("%s\n", name);
}

void initialize() {
    int seed;
    srand(seed);    
    for (int counter = 0; counter < 20; counter++) {
        if(rand() % 5 <= 0) {
            continue;
        } else {
            numbers[counter][0] = 'a' + rand() % 26;
        }
    }
}
