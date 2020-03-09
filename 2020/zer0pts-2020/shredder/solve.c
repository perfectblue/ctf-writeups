#include <stdio.h>
#include <stdlib.h>

int main() {
  FILE *fin = fopen("file", "r");
  FILE *fout = fopen("file.pdf", "w");

  srand(0xa31d4ea4);

  int c;
  while ((c = fgetc(fin))!=EOF) {
    fputc((char)(c ^ rand()), fout);
  }

  fclose(fin);
  fclose(fout);

}
