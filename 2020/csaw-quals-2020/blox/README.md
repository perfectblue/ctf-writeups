# Wargames (Blox 1 & 2)

This was a challenge where you had to reverse and exploit a binary that was running in this cloud reversing tool thing made by RET2 systems. However, I am stupid and I can't live without F5 so I dumped the whole binary with x/20480bx 0x40000 and put it into IDA. Then I setup the segments manually so I can press F5.

I really liked this challenge, it was well-thought out, clever, and also very rewarding at the end. Shame there was some technical difficulties with the online platform at the end, so they were forced to release the binary outright.

## Part 1

There is a tetris game and you need to draw RET2 using the blocks.

```
## #########
# ##   #   #
## ##  # ###
# ##   # #  
# #### # ###
```

I don't really feel like explaining the code but basically I just converted the check function to z3 code (see z3sice.py). Read the code yourself, there's comments

```c
__int64 check_cheat_codes()
{
  unsigned int groupnum; // [rsp+Ch] [rbp-4h]

  for ( groupnum = 0; groupnum <= 3; ++groupnum )// FOR_EACH_BLK
  {
    if ( !(unsigned int)check_cheatcodes_y(groupnum) || !(unsigned int)check_cheatcodes_x(groupnum) )
      return 0LL;
  }
  return 1LL;
}
__int64 __fastcall check_cheatcodes_x(int i)
{
  unsigned int y; // [rsp+8h] [rbp-Ch]
  char num_minos; // [rsp+Eh] [rbp-6h]
  char xor_sum; // [rsp+Fh] [rbp-5h]
  unsigned int x; // [rsp+10h] [rbp-4h]

  for ( x = 0; x <= 2; ++x )                    // Iterate thru cols in 4 groups of 3
  {
    xor_sum = 0;
    num_minos = 0;
    for ( y = 0; y <= 4; ++y )                  // Iterate thru 5 rows
    {
      if ( board[NCOLS * (unsigned __int64)(y + 15) + 3 * i + x] )
      {
        xor_sum ^= y + 1;
        ++num_minos;
      }
    }
    if ( xor_sum != cheatcode_xorsum_x[3 * i + x] || num_minos != cheatcode_numminos_x[3 * i + x] )
      return 0LL;
  }
  return 1LL;
}
__int64 __fastcall check_cheatcodes_y(int i)
{
  unsigned int x; // [rsp+8h] [rbp-Ch]
  char num_minos; // [rsp+Eh] [rbp-6h]
  char xor_sum; // [rsp+Fh] [rbp-5h]
  unsigned int y; // [rsp+10h] [rbp-4h]

  for ( y = 0; y <= 4; ++y )                    // Iterate thru 5 rows
  {
    xor_sum = 0;
    num_minos = 0;
    for ( x = 0; x <= 2; ++x )                  // Iterate thru cols in 4 groups of 3
    {
      if ( board[NCOLS * (unsigned __int64)(y + 15) + 3 * i + x] )// horizontal sum of this group of 3
      {
        xor_sum ^= x + 1;
        ++num_minos;
      }
    }
    if ( xor_sum != cheatcode_xorsum_y[5 * i + y] || num_minos != cheatcode_numminos_y[5 * i + y] )// check col-wise sum for all 5 rows for this group
      return 0LL;
  }
  return 1LL;
}
```

## Part 2

For part 2 you need to exploit the game to get arbitrary code execution (and syscall 1337 0x41414141)

Enabling cheats in part 1 gives you access to cheat codes that can let you change the tetramino as it's falling to whatever you want. The vulnerability is that using the tetramino-changing cheat can go out of bounds of the game board. If you put an O piece right on the edge of the game board and change it to a long piece (L J or I piece), it will extend outside of the game board and can overflow the game board buffer.

It just so happens that in the .bss, `heap_top` (their malloc is a simple bump allocator) is placed right after `board`. So we can basically do partial overwrites of the `heap_top` with values corresponding to tetramino L,J,I (1,2,3). We chose to do it with an I piece. This would place `heap_top` at 0x40012c in malloc. Each time we get a high score, `malloc(4)` is called allowing us to write a high score name into the buffer, consisting of up to 3 uppercase characters.

For x64 shellcode, only uppercase is insufficient to be useful for anything really. So we need to upgrade this primitive. We do so by getting high scores over and over, pushing `heap_top` through the .text section. Note the .text section is actually RWX so we can overwrite code as we please. We push it all thew ay into `check_high_score` and corrupt the input checks, allowing us to enter (nearly) arbitrary characters.

Then, we write in a shellcode for the syscall and that's it.

See lmao.py for exploit

flag{s0m3t1mes_y0u_n33d_t0_wr1t3_y0ur_0wn_kill_scr33n}
