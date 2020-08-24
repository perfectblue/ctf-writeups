# DotNet

Solved by tkoa and cts

Basically flag checker (see checks.cs), but there is some stupid instrumentation (Harmony) that hooks funcs so other funcs will run before them and optionally supersede them

```c#
// stupid instrumentation shit
internal static void VARDAGEN()
{
	Harmony harmony = new Harmony("fun");
	MethodInfo method = typeof(KVOT).GetMethod("FYRKANTIG", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	MethodInfo method2 = typeof(GATKAMOMILL).GetMethod("NUFFRA", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	harmony.Patch(method, new HarmonyMethod(method2), null, null, null);
	MethodInfo method3 = typeof(KVOT).GetMethod("RIKTIG_OGLA", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	MethodInfo method4 = typeof(GATKAMOMILL).GetMethod("GRONKULLA", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	harmony.Patch(method3, new HarmonyMethod(method4), null, null, null);
	MethodInfo method5 = typeof(SOCKERBIT).GetMethod("GRUNDTAL_NORRVIKEN", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	MethodInfo method6 = typeof(GATKAMOMILL).GetMethod("SPARSAM", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	harmony.Patch(method5, new HarmonyMethod(method6), null, null, null);
	MethodInfo method7 = typeof(FARGRIK).GetMethod("DAGSTORP", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	MethodInfo method8 = typeof(GATKAMOMILL).GetMethod("FLARDFULL", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	harmony.Patch(method7, new HarmonyMethod(method8), null, null, null);
}
```

- `KVOT.FYRKANTIG` -> `NUFFRA` : does the custom fryantig_impl if not debugged, this basically does some preprocessing on the input including the base64 decode in `NativeGRUNDTAL_NORRVIKEN` then the xor and shuffle
- `KVOT.RIKTIG_OGLA` -> `GRANKULLA` : if NOT debugged , do the init. this is just the initializer shit but like neither of them do nothing
- `SOCKERBIT` -> `SPARSAM` : do `SPARSAM` and SKIP if not debugged. (if debugged do original thang, tricky). original one does the base64 shit but we do not need to do it if we are doing the native FRYANTIG because the native code does base64 in `NativeGRUNDTAL_NORRVIKEN`. so we don't wanna base64 decode it a second time. sparsam just does puts the chars into a list without any decoding
- `DAGSTORP` -> `FLARDFULL` : basically skip if not debugged. original one does the xor but since we already did the xor in the native fryantig we don't wanna xor twice, duh

Also it has anti-debug detection but this is actuall fake news because i just use ScyllaHide in x64dbg and CHECK ALL THE BOXES LMAO like an idiot, works fine

There is also native FFI to C++. The native part decodes then fucks up the input a bit (xor, shuffle, and some swaps), then the C# flag checker is just z3 food.

There is a checksum in the flag checker but the checksum byte is unconstrained in the big z3 food part, so that can be just computed post hoc.

So the control flow REALLY looks like this

1. call `KVOT.FYRKANTIG`, the main flag checking func
2. but before it runs, it runs the Harmony hook `GATKAMOMILL.NUFFRA`
3. call native `NativeGRUNDTAL_NORRVIKEN`: decode
2. call native `FYRKANTIGImpl`
3. native `FYRKANTIGImpl`: xor
3. native `FYRKANTIGImpl`: shuffle
4. native `FYRKANTIGImpl`: bigChungus (does some swaps)
5. return from native code to c#, return from `NUFFRA` back to `KVOT.FYRKANTIG`.
6. check len == 30
7. call to `SOCKERBIT` is not replaced with call to `SPARSAM` which just copys the flag chars into the integer list
8. `FARGRIK.DAGSTORP` call is replaced with `FLARDFULL` which does nothing because we already did the xor in the native part
9. `SMORBOLL`: checksum check
6. `HEROISK`: z3 food check

then we just use z3py to solve it lol (`solve2.py`)

```
sat
[48, 25, 23, 19, 15, 26, 13, 57, 36, 9, 52, 27, 4, 18, 49, 6, 41, 8, 43, 62, 45, 55, 37, 32, 1, 0, 7, 28, 47, 2]
z3 soln:
[48, 25, 23, 19, 15, 26, 13, 57, 36, 9, 52, 27, 4, 18, 49, 6, 41, 8, 43, 62, 45, 55, 37, 32, 1, 0, 7, 28, 47, 2]
30 19 17 13 0f 1a 0d 39 24 09 34 1b 04 12 31 06 29 08 2b 3e 2d 37 25 20 01 00 07 1c 2f 02
unswapped:
[25, 48, 23, 15, 19, 26, 57, 13, 36, 52, 9, 27, 18, 4, 49, 41, 6, 8, 62, 43, 45, 37, 55, 32, 0, 1, 7, 28, 47, 2]
19 30 17 0f 13 1a 39 0d 24 34 09 1b 12 04 31 29 06 08 3e 2b 2d 25 37 20 00 01 07 1c 2f 02
unshuffled:
[19, 62, 48, 1, 23, 52, 4, 45, 43, 6, 27, 13, 25, 0, 28, 57, 41, 37, 7, 18, 49, 15, 26, 36, 8, 32, 55, 9, 47, 2]
13 3e 30 01 17 34 04 2d 2b 06 1b 0d 19 00 1c 39 29 25 07 12 31 0f 1a 24 08 20 37 09 2f 02
unxored:
[12, 29, 15, 62, 12, 51, 51, 12, 47, 53, 18, 54, 32, 40, 44, 53, 39, 11, 56, 55, 27, 40, 36, 47, 47, 60, 15, 56, 49, 63]
0c 1d 0f 3e 0c 33 33 0c 2f 35 12 36 20 28 2c 35 27 0b 38 37 1b 28 24 2f 2f 3c 0f 38 31 3f
CTF{CppClrIsWeirdButReallyFun}
```

also while i was testing, i would breakpoint, insert my hypothesized flag contents into the string buffer in x64dbg, and make sure that it was correct, at each step i was undoing the transformations to make sure I would not make some error early on and waste 999 hours on debugging it.

### Tutorial: how to go follow the Native <-> C# FFI

It was really confusing how to get back and forth between the C++ and C#. To go from native thunks to C#, you go to the thunk in ida

```c
// attributes: thunk
int __cdecl std_random_shuffle(int a1, int a2, int a3)
{
  return dword_4D8358(a1, a2, a3);
}
```

```
.text:00404EB3                       std_random_shuffle proc near            ; CODE XREF: do_shuffle+55↑p
.text:00404EB3 000 FF 25 58 83 4D 00     jmp     dword_4D8358
.text:00404EB3                       std_random_shuffle endp

data:004D8358 8B 00 00 06           dword_4D8358 dd 600008Bh 

```

Then this dword `600008Bh` is the MD entry id in c#. You can go to the corresponding c# code in dnSpy with "Go to MD Table Row", just put in 0x600008B

Then this will go to some tab like `139 - std.random_shuffle<class st...`, 139 is the RID here, so search RID: 139 in `<Module>` in c#

```c#
// Token: 0x0600008B RID: 139 RVA: 0x00003E98 File Offset: 0x00003298
internal unsafe static void random_shuffle<class\u0020std::_String_iterator<class\u0020std::_String_val<struct\u0020std::_Simple_types<char>\u0020>\u0020>,class\u0020<lambda_7b24d0a324c66665c2319d5904cf2705>\u0020>(_String_iterator<std::_String_val<std::_Simple_types<char>\u0020>\u0020> _First, _String_iterator<std::_String_val<std::_Simple_types<char>\u0020>\u0020> _Last, <lambda_7b24d0a324c66665c2319d5904cf2705>* _RngFunc)
{
	<Module>.std._Random_shuffle1<class\u0020std::_String_iterator<class\u0020std::_String_val<struct\u0020std::_Simple_types<char>\u0020>\u0020>,class\u0020<lambda_7b24d0a324c66665c2319d5904cf2705>\u0020>(_First, _Last, _RngFunc);
}
```

To go from c# to native FFI basically go to that native function in dnSpy, it will tell you the file offset

```c#
// Token: 0x06000116 RID: 278 RVA: 0x00001930 File Offset: 0x00000D30
[SuppressUnmanagedCodeSecurity]
[MethodImpl(MethodImplOptions.Unmanaged | MethodImplOptions.PreserveSig)]
[return: MarshalAs(UnmanagedType.U1)]
internal static extern bool GODDAG();
```

then just go to this file offset in IDA. how did I figure it out? I got frustrated in dnSpy, so i debugged it in dnSpy, check Disassembly of the JIT to find the address of `GODDAG` in JIT, detach with dnSpy and reattach with x64dbg, then breakpoint the JITted `GODDAG` and follow it to the RVA in the main binary. that's how i noticed the correspondence in the dnSpy output and the actual RVA in the binary.
