# Gibberish

**Category**: Reversing

200 Points

68 Solves

**Problem description**:

FIRST EVER CHALLLENNGEEEEEEEawedfhjawe;hfj

`nc rev.chal.csaw.io 1000`

---

Spoiler alert: it's possible to guess the flag from the challenge description. It's also possible to guess it by just using `strings`.

The binary itself is this tOxIc C++ binary (but at least it's not static+stripped). The long and short of it is, it initializes an array of strings. Then the program calculates the Levenshtein  distance between the input string and each string in the array. The total of these distances must be 505. Moreover there is anti-ptrace and anti-breakpoint tricks for anti-debugging, but it's trivial to just nop these out.

What makes this problem totally cheese-able is that if you just look at the array of strings in the program:

```
"dqzkenxmpsdoe_qkihmd",
"jffglzbo_zghqpnqqfjs",
"kdwx_vl_rnesamuxugap",
"ozntzohegxagreedxukr",
"xujaowgbjjhydjmmtapo",
"pwbzgymqvpmznoanomzx",
"qaqhrjofhfiuyt_okwxn",
"a_anqkczwbydtdwwbjwi",
"zoljafyuxinnvkxsskdu",
"irdlddjjokwtpbrrr_yj",
"cecckcvaltzejskg_qrc",
"vlpwstrhtcpxxnbbcbhv",
"spirysagnyujbqfhldsk",
"bcyqbikpuhlwordznpth",
"_xkiiusddvvicipuzyna",
"wsxyupdsqatrkzgawzbt",
"ybg_wmftbdcvlhhidril",
"ryvmngilaqkbsyojgify",
"mvefjqtxzmxf_vcyhelf",
"hjhofxwrk_rpwli_mxv_",
"enupmannieqqzcyevs_w",
"uhmvvb_cfgjkggjpavub",
"gktdphqiswomuwzvjtog",
"lgoehepwclbaifvtfoeq",
"nm_uxrukmof_fxsfpcqz",
"ttsbclzyyuslmutcylcm",
```

It forms a 26x20 matrix. So the input must be 20 characters long. Also interestingly each column has exactly 26 unique characters... and since the alphabet is a-z plus underscore, that means exactly one character is missing out of our alphabet. 🤔

So I just extracted those missing characters in Python and that was the flag.

```
$ nc rev.chal.csaw.io 1000
Find the Key!
first_ever_challenge
Correct!
flag{first_ever_challenge}
```

I told you it was guessable right!
