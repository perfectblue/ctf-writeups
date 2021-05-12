#include <stdint.h>

enum re_type {
  NUL, EPS, CHARS, NEG, ALT, AND, SEQ, STAR, FAN, LIT, MOON, CONSIDER
};

template <typename T>
struct heap {
  uint64_t x;
  uint64_t y;
  T v;
};

template <typename T>
struct vector {
  T *ptr;
  uint64_t cap;
  uint64_t len;
};

struct str {
  const char * ptr;
  uint64_t len;
};

struct range {
  uint32_t from;
  uint32_t to;
};

struct charset {
  uint32_t xx;
  range *ranges;
  uint64_t size;
};

struct consider_data {
  heap<vector<struct re_ent*>> *lst;
  uint64_t a;
  uint64_t b;
  uint64_t c;
};

struct fan_data {
  struct re_ent *ent;
  uint64_t times;
};

struct moon_data {
  struct re_ent *ent;
  uint64_t a;
  uint64_t b;
  uint64_t c;
};

struct re_ent {
  uint64_t myst1;
  uint64_t myst2;
  re_type type;
  union {
    charset         chars;
    re_ent*         neg;
    vector<re_ent*> alt;
    vector<re_ent*> ands;
    re_ent*         seq[2];
    re_ent*         star;
    fan_data        fan;
    str             lit;
    moon_data       moon;
    consider_data   consider;
  } v;
};

