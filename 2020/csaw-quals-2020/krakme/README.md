# Krakme

Basically the challenge is a flag checker implemented in OpenCL kernel

I wasted 30 minutes because my graphics driver is only CUDA 10, so I had to update nvidia driver and install CUDA 11. So the cool part of this challenge is my free disk space shrank

I then wasted like 1 hour trying to reverse the binary to extract the kernel. Guess what, you can dump it with `cuobjdump -all krakme.exe`

It outputs this ptx file, kernel.sm_52.ptx, which has all the code that runs on the gpu thread. Interesting note about gpu architecture, it is SIMT (Single instruction multi thread). You might have heard of SIMD (Single instruction multiple data), but actually Nvidia is BIG BRAIN. (That's why I buy nvidia stock on robinhood because stonks only goes up. until 2 weeks ago 😠). Graphics pipeline is SIM**T**!!! You have all these cuda cores can all run your code simultaneously so it is as if the thread's code is running massively in parallel. Anyways that's not relevant to the challenge but I thought it was an interesting thing to discuss.

![simt](https://www.researchgate.net/profile/Daniel_Etiemble/publication/323510528/figure/fig6/AS:631606020669459@1527598018120/SIMD-and-SIMT-data-parallelism.png)

Based on my poor understanding, Ptx is essentially this IL that will get compiled to the raw machine code the device wants at runtime. But the instruction set itself is very easy to understand if this isn't your first rodeo. Here i will paste the code, so the writeup has a nice visual aesthetic because its ugly to just have paragraphs. But i am sure you probably won't read the code anyways so just skip past the code block and i'll explain the rest in plain english

```
.global .align 1 .b8 $strCorrect[18] = {67, 79, 82, 82, 69, 67, 84, 32, 80, 65, 83, 83, 87, 79, 82, 68, 33, 0};
.global .align 1 .b8 $str1WrongPassword[27] = {87, 82, 79, 78, 71, 32, 80, 65, 83, 83, 87, 79, 82, 68, 44, 32, 84, 82, 89, 32, 65, 71, 65, 73, 78, 33, 0};



-- build flag on the stack xor against flag index then check

.visible .entry _Z11checkKernelPKcPKiPi(
	.param .u64 _Z11checkKernelPKcPKiPi_param_0,
	.param .u64 _Z11checkKernelPKcPKiPi_param_1,
	.param .u64 _Z11checkKernelPKcPKiPi_param_2
)
{
	.local .align 1 .b8 __local_depot6[31];
	.reg .b64 %SP;
	.reg .b64 %SPL;
	.reg .pred %p<9>;
	.reg .b16 %rs<27>;
	.reg .b32 %r<23>;
	.reg .b64 %rd<15>;


	.loc 1 11 1
	func_begin6:
	.loc	1 0 0

	.loc 1 11 1

	mov.u64 %SPL, __local_depot6;
	cvta.local.u64 %SP, %SPL;
	ld.param.u64 %rd1, [_Z11checkKernelPKcPKiPi_param_0];
	ld.param.u64 %rd2, [_Z11checkKernelPKcPKiPi_param_1];
	ld.param.u64 %rd3, [_Z11checkKernelPKcPKiPi_param_2];
	tmp12:
	func_exec_begin6:
	.loc	1 13 13
	mov.u32 %r8, 0;
	mov.b32 %r1, %r8;
	tmp13:
	mov.u16 %rs1, 99;
	.loc	1 14 18
	st.u8 [%SP+30], %rs1;
	mov.u16 %rs2, 103;
	st.u8 [%SP+29], %rs2;
	mov.u16 %rs3, 104;
	st.u8 [%SP+28], %rs3;
	mov.u16 %rs4, 122;
	st.u8 [%SP+27], %rs4;
	mov.u16 %rs5, 41;
	st.u8 [%SP+26], %rs5;
	mov.u16 %rs6, 113;
	st.u8 [%SP+25], %rs6;
	mov.u16 %rs7, 123;
	st.u8 [%SP+24], %rs7;
	mov.u16 %rs8, 72;
	st.u8 [%SP+23], %rs8;
	mov.u16 %rs9, 120;
	st.u8 [%SP+22], %rs9;
	mov.u16 %rs10, 74;
	st.u8 [%SP+21], %rs10;
	st.u8 [%SP+20], %rs2;
	st.u8 [%SP+19], %rs1;
	st.u8 [%SP+18], %rs7;
	mov.u16 %rs11, 125;
	st.u8 [%SP+17], %rs11;
	mov.u16 %rs12, 114;
	st.u8 [%SP+16], %rs12;
	mov.u16 %rs13, 80;
	st.u8 [%SP+15], %rs13;
	mov.u16 %rs14, 96;
	st.u8 [%SP+14], %rs14;
	mov.u16 %rs15, 100;
	st.u8 [%SP+13], %rs15;
	mov.u16 %rs16, 83;
	st.u8 [%SP+12], %rs16;
	mov.u16 %rs17, 56;
	st.u8 [%SP+11], %rs17;
	st.u8 [%SP+10], %rs2;
	mov.u16 %rs18, 86;
	st.u8 [%SP+9], %rs18;
	mov.u16 %rs19, 124;
	st.u8 [%SP+8], %rs19;
	mov.u16 %rs20, 52;
	st.u8 [%SP+7], %rs20;
	mov.u16 %rs21, 53;
	st.u8 [%SP+6], %rs21;
	st.u8 [%SP+5], %rs3;
	mov.u16 %rs22, 127;
	st.u8 [%SP+4], %rs22;
	st.u8 [%SP+3], %rs15;
	st.u8 [%SP+2], %rs1;
	mov.u16 %rs23, 109;
	st.u8 [%SP+1], %rs23;
	mov.u16 %rs24, 102;
	st.u8 [%SP+0], %rs24;
	.loc	1 15 5
	ld.u32 %r9, [%rd2];
	setp.ne.s32	%p1, %r9, 31;
	not.pred %p2, %p1;
	@%p2 bra BB6_2;
	bra.uni BB6_1;

	BB6_1:
	.loc	1 16 9
	tmp14:
	mov.u32 %r19, -1;
	st.u32 [%rd3], %r19;
	.loc	1 17 9
	bra.uni BB6_12;
	tmp15:

	BB6_2:
	.loc	1 20 16
	mov.u32 %r10, 0;
	mov.b32 %r2, %r10;
	tmp16:
	mov.u32 %r20, %r1;
	tmp17:
	mov.u32 %r21, %r2;
	tmp18:

	BB6_3:
	.loc	1 20 5
	mov.u32 %r4, %r21;
	mov.u32 %r3, %r20;
	tmp19:
	ld.u32 %r11, [%rd2];
	setp.lt.s32	%p3, %r4, %r11; -- counter vs input length check
	not.pred %p4, %p3;
	@%p4 bra BB6_8;
	bra.uni BB6_4;

	BB6_4:
	.loc	1 22 9
	tmp20:
	cvt.s64.s32	%rd10, %r4;
	add.s64 %rd11, %rd1, %rd10; -- index into flagbuf
	ld.u8 %rs25, [%rd11]; -- input char
	cvt.u32.u16	%r14, %rs25;
	cvt.s32.s8 %r15, %r14;
	xor.b32 %r16, %r15, %r4; -- xor input char with counter
	cvt.s64.s32	%rd12, %r4;
	add.u64 %rd13, %SP, 0;
	add.s64 %rd14, %rd13, %rd12; -- index into Stackbuf
	ld.u8 %rs26, [%rd14]; -- flag char
	cvt.u32.u16	%r17, %rs26;
	cvt.s32.s8 %r18, %r17;
	setp.eq.s32	%p7, %r16, %r18; -- compare flag char with xored input char
	not.pred %p8, %p7;
	mov.u32 %r22, %r3;
	tmp21:
	@%p8 bra BB6_6;
	bra.uni BB6_5;

	BB6_5:
	.loc	1 23 13
	tmp22:
	add.s32 %r5, %r3, 1;
	tmp23:
	mov.u32 %r22, %r5;
	tmp24:

	BB6_6:
	.loc	1 20 32
	mov.u32 %r6, %r22;
	tmp25:

	add.s32 %r7, %r4, 1; -- increment counter
	tmp26:
	mov.u32 %r20, %r6;
	tmp27:
	mov.u32 %r21, %r7;
	tmp28:
	bra.uni BB6_3;
	tmp29:

	BB6_8:
	.loc	1 26 5
	setp.eq.s32	%p5, %r3, 31;
	not.pred %p6, %p5;
	@%p6 bra BB6_10;
	bra.uni BB6_9;

	BB6_9:
	.loc	1 27 9
	tmp30:
	mov.u64 %rd7, $strCorrect;
	cvta.global.u64 %rd8, %rd7;
	mov.u64 %rd9, 0;

	{
		.reg .b32 temp_param_reg;

		.param .b64 param0;
		st.param.b64	[param0+0], %rd8;
		.param .b64 param1;
		st.param.b64	[param1+0], %rd9;
		.param .b32 retval0;
		call.uni (retval0), 
		vprintf, 
		(
		param0, 
		param1
		);
		ld.param.b32	%r13, [retval0+0];
	}
	bra.uni BB6_11;
	tmp31:

	BB6_10:
	.loc	1 30 9
	mov.u64 %rd4, $str1WrongPassword;
	cvta.global.u64 %rd5, %rd4;
	mov.u64 %rd6, 0;

	{
		.reg .b32 temp_param_reg;

		.param .b64 param0;
		st.param.b64	[param0+0], %rd5;
		.param .b64 param1;
		st.param.b64	[param1+0], %rd6;
		.param .b32 retval0;
		call.uni (retval0), 
		vprintf, 
		(
			param0, 
			param1
		);
		ld.param.b32	%r12, [retval0+0];
	}
	tmp32:

	BB6_11:

	BB6_12:
	.loc	1 32 5
	ret;
	tmp33:
	func_end6:
}
```

Your input must be 32 bytes including null terminator. The flag checking function builds flag buffer on the stack. For each byte of your input, it is xored with the character index (0,1,2,..etc). This is compared with the flag buffer. So we just xor the flag buffer with index to get the flag

```python
sice = [102, 109, 99, 100, 127, 104, 53, 52, 124, 86, 103, 56, 83, 100, 96, 80, 114, 125, 123, 99, 103, 74, 120, 72, 123, 113, 41, 122, 104, 103, 99, 0]
buf = ''
for i , c in enumerate(sice):
	buf += chr(c ^ i)
print(buf)
```

# flag{m33t_m3_in_blips_n_ch3atz}


Btw, as a bonus, I made IDA FLIRT signature and type library for CUDA RT 11.0 just for fun, i include these in the repo.
