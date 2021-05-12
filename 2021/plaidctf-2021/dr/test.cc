#include <cstdio>
#include <cstring>
#include <cstdlib>
#include "re.hpp"

void dump_re_(re_ent *re, int depth=1);

extern "C" {

void dump_re(re_ent *re) {
  setbuf(stdout, NULL);
  dump_re_(re);
}

}

void clobber(re_ent *ent) {
  re_ent *tmp;
#if 0
  tmp = (struct re_ent *)malloc(sizeof(*tmp));
  tmp->myst1 = 1;
  tmp->myst2 = 1;
  tmp->type = LIT;
  tmp->v.lit.ptr = "0";
  tmp->v.lit.len = 1;

  ent->type = STAR;
  ent->v.star = tmp;
#endif

#if 0
  tmp = (struct re_ent *)malloc(sizeof(*tmp));
  tmp->myst1 = 1;
  tmp->myst2 = 1;
  tmp->type = LIT;
  tmp->v.lit.ptr = "H";
  tmp->v.lit.len = 1;

  ent->type = MOON;
  ent->v.moon.ent = tmp;
  ent->v.moon.a = 2;
  ent->v.moon.b = 5;
#endif

#if 1
  tmp = ent->v.ands.ptr[1];
  memcpy(&ent->type, &tmp->type, sizeof(*ent) - 0x10);
#endif

#if 0
  struct re_ent **ents = (typeof(ents))calloc(sizeof(*ents), 4);
  tmp = (struct re_ent *)malloc(sizeof(*tmp));
  tmp->myst1 = 1;
  tmp->myst2 = 1;
  tmp->type = LIT;
  tmp->v.lit.ptr = "H";
  tmp->v.lit.len = 1;
  ents[0] = tmp;

  tmp = (struct re_ent *)malloc(sizeof(*tmp));
  tmp->myst1 = 1;
  tmp->myst2 = 1;
  tmp->type = LIT;
  tmp->v.lit.ptr = "h";
  tmp->v.lit.len = 1;
  ents[1] = tmp;

  tmp = (struct re_ent *)malloc(sizeof(*tmp));
  tmp->myst1 = 1;
  tmp->myst2 = 1;
  tmp->type = LIT;
  tmp->v.lit.ptr = "I";
  tmp->v.lit.len = 1;
  ents[2] = tmp;

  tmp = (struct re_ent *)malloc(sizeof(*tmp));
  tmp->myst1 = 1;
  tmp->myst2 = 1;
  tmp->type = LIT;
  tmp->v.lit.ptr = "i";
  tmp->v.lit.len = 1;
  ents[3] = tmp;

  heap<vector<struct re_ent*>> *x = (typeof(x))malloc(sizeof(*x));
  x->x = 1;
  x->y = 1;
  x->v.len = 4;
  x->v.ptr = ents;

  ent->type = CONSIDER;
  ent->v.consider.lst = x;
  ent->v.consider.a = 0; // starting
  ent->v.consider.b = 10000; // target value
  ent->v.consider.c = 10000; // modulus
#endif
}

void dump_vector(const vector<re_ent*> &vec, int depth) {
  for (uint64_t i = 0; i < vec.len; i++)
    dump_re_(vec.ptr[i], depth + 1);
}

void dump_re_(re_ent *ent, int depth) {
  printf("%*c", depth * 2, ' ');
  switch (ent->type) {
  case NUL:
    puts("NUL");
    break;
  case EPS:
    puts("EPS");
    break;
  case CHARS:
    printf("CHARS: ");
    for (uint64_t i = 0; i < ent->v.chars.size; i++) {
      range rv = ent->v.chars.ranges[i + 1];
      printf("%c '%c'-'%c'", i == 0 ? '{' : ',', rv.from, rv.to);
    }
    puts(" }");
    break;
  case NEG:
    puts("NEG:");
    dump_re_(ent->v.neg, depth + 1);
    break;
  case ALT:
    puts("ALT:");
    dump_vector(ent->v.alt, depth + 1);
    break;
  case AND:
    puts("AND:");
    dump_vector(ent->v.alt, depth + 1);
    break;
  case SEQ:
    puts("SEQ:");
    dump_re_(ent->v.seq[0], depth + 1);
    dump_re_(ent->v.seq[1], depth + 1);
    break;
  case STAR:
    puts("STAR:");
    dump_re_(ent->v.star, depth + 1);
    break;
  case FAN:
    printf("FAN: %d\n", ent->v.fan.times);
    dump_re_(ent->v.fan.ent, depth + 1);
    break;
  case LIT: {
    uint64_t len = ent->v.lit.len;
    char *buff = (char*)malloc(len + 1);
    strncpy(buff, ent->v.lit.ptr, len + 1);
    buff[len] = 0;
    printf("LIT: \"%s\"\n", buff);
    free(buff);
    break;
  }
  case MOON:
    printf("MOON(%d, %d)\n", ent->v.moon.a, ent->v.moon.b);
    dump_re_(ent->v.moon.ent, depth + 1);
    break;
  case CONSIDER:
    printf("CONSIDER(%d, %d, %d)\n", ent->v.consider.a, ent->v.consider.b,
           ent->v.consider.c);
    dump_vector(ent->v.consider.lst->v, depth);
    break;
  default:
    puts("UNKNOWN:");
  }

}
