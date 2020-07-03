
../../babymips:     file format elf32-littlenanomips

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .interp       0000001e  00400154  00400154  00000154  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  1 .dynsym       00000100  00400174  00400174  00000174  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .dynstr       000000d0  00400274  00400274  00000274  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .gnu.hash     00000034  00400344  00400344  00000344  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .rel.dyn      00000028  00400378  00400378  00000378  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  5 .rel.nanoMIPS.stubs 00000028  004003a0  004003a0  000003a0  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  6 .init         00000008  004003c8  004003c8  000003c8  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  7 .nanoMIPS.stubs 00000026  004003d0  004003d0  000003d0  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  8 .text         00000398  004003f6  004003f6  000003f6  2**1
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  9 .fini         00000008  00400790  00400790  00000790  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 10 .rodata       0000007e  00400798  00400798  00000798  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 11 .nanoMIPS.abiflags 00000018  00400818  00400818  00000818  2**3
                  CONTENTS, ALLOC, LOAD, READONLY, DATA, LINK_ONCE_SAME_SIZE
 12 .eh_frame     00000004  00400830  00400830  00000830  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 13 .eh_frame_hdr 00000008  00400834  00400834  00000834  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 14 .init_array   00000004  0041ff24  0041ff24  0000ff24  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 15 .fini_array   00000004  0041ff28  0041ff28  0000ff28  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 16 .jcr          00000004  0041ff2c  0041ff2c  0000ff2c  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 17 .dynamic      000000d0  0041ff30  0041ff30  0000ff30  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 18 .data         000000a5  00420000  00420000  00010000  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 19 .tm_clone_table 00000000  004200a8  004200a8  000100a8  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 20 .sdata        00000004  004200a8  004200a8  000100a8  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 21 .got          00000038  004200ac  004200ac  000100ac  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 22 .bss          0000001c  004200e4  004200e4  000100e4  2**2
                  ALLOC
 23 .comment      00000040  00000000  00000000  000100e4  2**0
                  CONTENTS, READONLY
 24 .note.gnu.gold-version 0000001c  00000000  00000000  00010124  2**2
                  CONTENTS, READONLY
Contents of section .interp:
 400154 2f6c6962 2f6c642d 6d75736c 2d6e616e  /lib/ld-musl-nan
 400164 6f6d6970 732d7366 2e736f2e 3100      omips-sf.so.1.  
Contents of section .dynsym:
 400174 00000000 00000000 00000000 00000000  ................
 400184 01000000 00000000 00000000 12000000  ................
 400194 1f000000 00000000 00000000 20000000  ............ ...
 4001a4 3b000000 00000000 00000000 20000000  ;........... ...
 4001b4 55000000 00000000 00000000 22000000  U..........."...
 4001c4 6d000000 00000000 00000000 22000000  m..........."...
 4001d4 83000000 00000000 00000000 20000000  ............ ...
 4001e4 97000000 00000000 00000000 12000000  ................
 4001f4 9e000000 00000000 00000000 12000000  ................
 400204 a3000000 00000000 00000000 12000000  ................
 400214 ab000000 00000000 00000000 12000000  ................
 400224 b0000000 e4004200 00000000 10000f00  ......B.........
 400234 c3000000 00014200 00000000 10000f00  ......B.........
 400244 19000000 c8034000 00000000 12000700  ......@.........
 400254 b7000000 e4004200 00000000 10000f00  ......B.........
 400264 13000000 90074000 00000000 12000a00  ......@.........
Contents of section .dynstr:
 400274 005f5f6c 6962635f 73746172 745f6d61  .__libc_start_ma
 400284 696e005f 66696e69 005f696e 6974005f  in._fini._init._
 400294 49544d5f 64657265 67697374 6572544d  ITM_deregisterTM
 4002a4 436c6f6e 65546162 6c65005f 49544d5f  CloneTable._ITM_
 4002b4 72656769 73746572 544d436c 6f6e6554  registerTMCloneT
 4002c4 61626c65 005f5f64 65726567 69737465  able.__deregiste
 4002d4 725f6672 616d655f 696e666f 005f5f72  r_frame_info.__r
 4002e4 65676973 7465725f 6672616d 655f696e  egister_frame_in
 4002f4 666f005f 4a765f52 65676973 74657243  fo._Jv_RegisterC
 400304 6c617373 6573006d 656d7365 74007265  lasses.memset.re
 400314 61640073 74726e63 6d700070 75747300  ad.strncmp.puts.
 400324 5f656461 7461005f 5f627373 5f737461  _edata.__bss_sta
 400334 7274005f 656e6400 6c696263 2e736f00  rt._end.libc.so.
Contents of section .gnu.hash:
 400344 03000000 0b000000 01000000 05000000  ................
 400354 086400a9 0b000000 0d000000 0f000000  .d..............
 400364 4245d5ec bbe3927c b88df10e d971581c  BE.....|.....qX.
 400374 ebd3ef0e                             ....            
Contents of section .rel.dyn:
 400378 bc004200 0a020000 c0004200 0a030000  ..B.......B.....
 400388 c4004200 0a040000 c8004200 0a050000  ..B.......B.....
 400398 cc004200 0a060000                    ..B.....        
Contents of section .rel.nanoMIPS.stubs:
 4003a0 d0004200 0b080000 d4004200 0b090000  ..B.......B.....
 4003b0 d8004200 0b0a0000 dc004200 0b070000  ..B.......B.....
 4003c0 e0004200 0b010000                    ..B.....        
Contents of section .init:
 4003c8 e2832430 e2832730                    ..$0..'0        
Contents of section .nanoMIPS.stubs:
 4003d0 00030000 18180003 01001218 00030200  ................
 4003e0 0c180003 03000618 00030400 00182043  .............. C
 4003f0 0200ff11 30db                        ....0.          
Contents of section .text:
 4003f6 c0138005 1400a104 30fb8107 a8fc9d10  ........0.......
 400406 20801080 3d2050ea 90d9e283 14308107   ...= P......0..
 400416 94fc4193 c0164041 36008004 c0022011  ..A...@A6..... .
 400426 0b6188fc 0100eb60 86fc0100 50d9e104  .a.....`....P...
 400436 70fc8104 6cfceb90 7fb2fcc8 0a38eb60  p...l........8.`
 400446 72fc0100 829be0d8 e0db8104 54fc02d3  r...........T...
 400456 e1044efc 7fb2e780 82c0c720 18298a9a  ..N........ .)..
 400466 eb6054fc 0100829b e0d8e0db 121ee2e0  .`T.............
 400476 0200c784 e4200712 16bbb33b eb603cfc  ..... .....;.`<.
 400486 0100869b 8004a203 f0d881d3 f084e410  ................
 400496 121f111e eb6028fc 01008a9b a10442fc  .....`(.......B.
 4004a6 80048603 f0d88104 7cfac017 86bbe183  ........|.......
 4004b6 1230971b eb600cfc 0100f39b f0d8ef1b  .0...`..........
 4004c6 521cdd83 b08f83b4 05b406b4 07b408b4  R...............
 4004d6 09b40ab4 0bb40cb4 0db40fb4 6c18ef34  ............l..4
 4004e6 c334eeb3 f85fe780 6180ecc8 52d0c004  .4..._..a...R...
 4004f6 a0027d53 06480080 e534e990 e5b44418  ..}S.H...4....D.
 400506 e634e990 e6b43c18 e734e990 e7b43418  .4....<..4....4.
 400516 e834e990 e8b42c18 e934e990 e9b42418  .4....,..4....$.
 400526 ea34e990 eab41c18 eb34e990 ebb41418  .4.......4......
 400536 ec34e990 ecb40c18 ed34e990 edb40418  .4.......4......
 400546 e0103218 ef34e990 efb4ef34 f8c88f4f  ..2..4.....4...O
 400556 0eb41a18 ee34f233 5073eeb3 e7a4d4c0  .....4.3Ps......
 400566 e0c80408 e0100e18 ee34e990 eeb4ee34  .........4.....4
 400576 f8c8e14f 81d38710 521dc283 3030dd83  ...O....R...00..
 400586 d08f03b4 04b41d84 141007b4 4c1806b4  ............L...
 400596 2e18c734 e610f333 7eb3c104 b0fa7cb3  ...4...3~.....|.
 4005a6 e634eeb3 f85fc710 e1044efa eeb3785f  .4..._....N...x_
 4005b6 e634c872 deb3c7a4 ec88e634 e990e6b4  .4.r.......4....
 4005c6 e634f8c8 cd4fc373 8710f53a e41084bb  .4...O.s...:....
 4005d6 e0100e18 e734e990 e7b4e734 f8c8af4f  .....4.....4...O
 4005e6 81d38710 c2833330 c2833030 dd83d08f  ......30..00....
 4005f6 03b404b4 1d841410 07b44218 06b42418  ..........B...$.
 400606 c634e610 f3337cb3 e734ecb3 e104eaf9  .4...3|..4......
 400616 eeb3785f e634c872 deb3c7a4 ec88e634  ..x_.4.r.......4
 400626 e990e6b4 e634f8c8 d74fc373 8710913a  .....4...O.s...:
 400636 e41084bb e0100e18 e734e990 e7b4e734  .........4.....4
 400646 f8c8b94f 81d38710 c2833330 c2833030  ...O......30..00
 400656 dd83d08f 03b404b4 1d841410 07b44218  ..............B.
 400666 06b42418 c734e610 f3337cb3 e634ecb3  ..$..4...3|..4..
 400676 e10486f9 eeb3785f e634c872 deb3c7a4  ......x_.4.r....
 400686 ec88e634 e990e6b4 e634f8c8 d74fc373  ...4.....4...O.s
 400696 87102d3a e41084bb e0100e18 e734e990  ..-:.........4..
 4006a6 e7b4e734 f8c8b94f 81d38710 c2833330  ...4...O......30
 4006b6 c2831030 dd83f08f c13ae410 84bbe010  ...0.....:......
 4006c6 1618253b e41084bb e0100c18 7f3be410  ..%;.........;..
 4006d6 84bbe010 021881d3 8710c283 1330c383  .............0..
 4006e6 8430dd83 808f8107 bcf9c373 5ad367bc  .0.........sZ.g.
 4006f6 e0403200 f0d8c373 3ed3e3bc e0402600  .@2....s>....@&.
 400706 f0d8fd84 4920f3c8 6ce8c373 05d3a004  ....I ..l..s....
 400716 e8008710 e0402a00 f0d8e410 d8bb1bb4  .....@*.........
 400726 85d3fab4 2c18fb34 e990fbb4 c104caf8  ....,..4........
 400736 fb34eeb3 f85fefbb fa345c73 eeb3c7a4  .4..._...4\s....
 400746 9c90a104 b4f8fb34 deb3745f fa34e990  .......4..t_.4..
 400756 fab4fa34 f9c8d5ef 573be410 8c9b8004  ...4....W;......
 400766 a000e040 2e00f0d8 16188004 9c00e040  ...@...........@
 400776 2e00f0d8 0a188004 9000e040 2e00f0d8  ...........@....
 400786 e0108710 c3838730                    .......0        
Contents of section .fini:
 400790 e2832430 e2832730                    ..$0..'0        
Contents of section .rodata:
 400798 0c000000 24000000 08000000 14000000  ....$...........
 4007a8 20000000 24000000 24000000 24000000   ...$...$...$...
 4007b8 24000000 24000000 24000000 24000000  $...$...$...$...
 4007c8 24000000 24000000 24000000 24000000  $...$...$...$...
 4007d8 18000000 24000000 10000000 24000000  ....$.......$...
 4007e8 24000000 24000000 1c000000 04000000  $...$...........
 4007f8 24000000 00000000 666c6167 7b000000  $.......flag{...
 400808 52696768 74000000 57726f6e 6700      Right...Wrong.  
Contents of section .nanoMIPS.abiflags:
 400818 00002006 01000003 00000000 01000400  .. .............
 400828 00000000 00000000                    ........        
Contents of section .eh_frame:
 400830 00000000                             ....            
Contents of section .eh_frame_hdr:
 400834 011bffff f8ffffff                    ........        
Contents of section .init_array:
 41ff24 98044000                             ..@.            
Contents of section .fini_array:
 41ff28 72044000                             r.@.            
Contents of section .jcr:
 41ff2c 00000000                             ....            
Contents of section .dynamic:
 41ff30 03000000 ac004200 02000000 28000000  ......B.....(...
 41ff40 17000000 a0034000 14000000 11000000  ......@.........
 41ff50 11000000 78034000 12000000 28000000  ....x.@.....(...
 41ff60 13000000 08000000 15000000 00000000  ................
 41ff70 06000000 74014000 0b000000 10000000  ....t.@.........
 41ff80 05000000 74024000 0a000000 d0000000  ....t.@.........
 41ff90 f5feff6f 44034000 01000000 c8000000  ...oD.@.........
 41ffa0 0c000000 c8034000 0d000000 90074000  ......@.......@.
 41ffb0 19000000 24ff4100 1b000000 04000000  ....$.A.........
 41ffc0 1a000000 28ff4100 1c000000 04000000  ....(.A.........
 41ffd0 00000000 00000000 00000000 00000000  ................
 41ffe0 00000000 00000000 00000000 00000000  ................
 41fff0 00000000 00000000 00000000 00000000  ................
Contents of section .data:
 420000 00007700 00007300 00000000 64000077  ..w...s.....d..w
 420010 00006400 00000000 61000000 65007700  ..d.....a...e.w.
 420020 71006100 65000000 00000000 00610000  q.a.e........a..
 420030 7a640000 73777100 00000077 00007378  zd..swq....w..sx
 420040 00640000 0000007a 77000000 00000064  .d.....zw......d
; trans = 0x420054
 420050 78000000 00010203 0a0c0d0e 13040506  x...............
 420060 0f181921 2a330708 10111a22 232b3409  ...!*3....."#+4.
 420070 121b242d 36373f48 0b14151c 1d1e252e  ..$-67?H......%.
 420080 2716171f 2028313a 4243262f 30383940  '... (1:BC&/089@
 420090 41494a29 323b3c3d 444b4c4d 2c353e45  AIJ)2;<=DKLM,5>E
 4200a0 46474e4f 50                          FGNOP           
Contents of section .sdata:
 4200a8 00000000                             ....            
Contents of section .got:
 4200ac 00000000 00000080 90074000 c8034000  ..........@...@.
 4200bc 00000000 00000000 00000000 00000000  ................
 4200cc 00000000 d0034000 d6034000 dc034000  ......@...@...@.
 4200dc e2034000 e8034000                    ..@...@.        
Contents of section .comment:
 0000 00474343 3a202843 6f646573 63617065  .GCC: (Codescape
 0010 20474e55 20546f6f 6c732032 3031392e   GNU Tools 2019.
 0020 30332d30 3620666f 72206e61 6e6f4d49  03-06 for nanoMI
 0030 5053204c 696e7578 2920362e 332e3000  PS Linux) 6.3.0.
Contents of section .note.gnu.gold-version:
 0000 04000000 09000000 04000000 474e5500  ............GNU.
 0010 676f6c64 20312e31 35000000           gold 1.15...    

Disassembly of section .init:

004003c8 <_init>:
  4003c8:	83e2 3024 	save	32,ra,gp
  4003cc:	83e2 3027 	restore.jrc	32,ra,gp

Disassembly of section .nanoMIPS.stubs:

004003d0 <.nanoMIPS.stubs>:
.read:
  4003d0:	0300 0000 	li	t8,0
  4003d4:	1818      	bc	4003ee <_init+0x26>

.strncmp:
  4003d6:	0300 0001 	li	t8,1
  4003da:	1812      	bc	4003ee <_init+0x26>

.puts:
  4003dc:	0300 0002 	li	t8,2
  4003e0:	180c      	bc	4003ee <_init+0x26>

.memset:
  4003e2:	0300 0003 	li	t8,3
  4003e6:	1806      	bc	4003ee <_init+0x26>

.__libc_start_main:
  4003e8:	0300 0004 	li	t8,4
  4003ec:	1800      	bc	4003ee <_init+0x26>

  4003ee:	4320 0002 	lw	t9,0(gp)
  4003f2:	11ff      	move	t3,ra
  4003f4:	db30      	jalrc	t9

Disassembly of section .text:

004003f6 <.text>:
  4003f6:	13c0      	move	fp,zero
  4003f8:	0580 0014 	lapc	t0,400410 <_init+0x48>
  4003fc:	04a1 fb30 	lapc	a1,41ff30 <_fini+0x1f7a0>
  400400:	0781 fca8 	lapc	gp,4200ac <_fini+0x1f91c>
  400404:	109d      	move	a0,sp
  400406:	8020 8010 	li	at,-16
  40040a:	203d ea50 	and	sp,sp,at
  40040e:	d990      	jalrc	t0

start:
  400410:	83e2 3014 	save	16,ra,gp
  400414:	0781 fc94 	lapc	gp,4200ac <_fini+0x1f91c>
  400418:	9341      	addiu	a2,a0,4
  40041a:	16c0      	lw	a1,0(a0)
  40041c:	4140 0036 	lw	a6,52(gp)
  400420:	0480 02c0 	lapc	a0,4006e4 <main>
  400424:	1120      	move	a5,zero
  400426:	610b fc88 	lwpc	a4,4200b4 <_fini+0x1f924>
  40042a:	0001 
  40042c:	60eb fc86 	lwpc	a3,4200b8 <_fini+0x1f928>
  400430:	0001 
  400432:	d950      	jalrc	a6

  400434:	04e1 fc70 	lapc	a3,4200a8 <_fini+0x1f918>
  400438:	0481 fc6c 	lapc	a0,4200a8 <_fini+0x1f918>
  40043c:	90eb      	addiu	a3,a3,3
  40043e:	b27f      	subu	a3,a3,a0
  400440:	c8fc 380a 	bltiuc	a3,7,40044e <_init+0x86>
  400444:	60eb fc72 	lwpc	a3,4200bc <_ITM_deregisterTMCloneTable>
  400448:	0001 
  40044a:	9b82      	beqzc	a3,40044e <_init+0x86>
  40044c:	d8e0      	jrc	a3
  40044e:	dbe0      	jrc	ra
  400450:	0481 fc54 	lapc	a0,4200a8 <_fini+0x1f918>
  400454:	d302      	li	a2,2
  400456:	04e1 fc4e 	lapc	a3,4200a8 <_fini+0x1f918>
  40045a:	b27f      	subu	a3,a3,a0
  40045c:	80e7 c082 	sra	a3,a3,2
  400460:	20c7 2918 	div	a1,a3,a2
  400464:	9a8a      	beqzc	a1,400470 <_init+0xa8>
  400466:	60eb fc54 	lwpc	a3,4200c0 <_ITM_registerTMCloneTable>
  40046a:	0001 
  40046c:	9b82      	beqzc	a3,400470 <_init+0xa8>
  40046e:	d8e0      	jrc	a3
  400470:	dbe0      	jrc	ra
  400472:	1e12      	save	16,ra,s0
  400474:	e0e2 0002 	aluipc	a3,0x20
  400478:	84c7 20e4 	lbu	a2,228(a3)
  40047c:	1207      	move	s0,a3
  40047e:	bb16      	bnezc	a2,400496 <_init+0xce>
  400480:	3bb3      	balc	400434 <_init+0x6c>
  400482:	60eb fc3c 	lwpc	a3,4200c4 <__deregister_frame_info>
  400486:	0001 
  400488:	9b86      	beqzc	a3,400490 <_init+0xc8>
  40048a:	0480 03a2 	lapc	a0,400830 <_fini+0xa0>
  40048e:	d8f0      	jalrc	a3
  400490:	d381      	li	a3,1
  400492:	84f0 10e4 	sb	a3,228(s0)
  400496:	1f12      	restore.jrc	16,ra,s0

  400498:	1e11      	save	16,ra
  40049a:	60eb fc28 	lwpc	a3,4200c8 <__register_frame_info>
  40049e:	0001 
  4004a0:	9b8a      	beqzc	a3,4004ac <_init+0xe4>
  4004a2:	04a1 fc42 	lapc	a1,4200e8 <__bss_start+0x4>
  4004a6:	0480 0386 	lapc	a0,400830 <_fini+0xa0>
  4004aa:	d8f0      	jalrc	a3
  4004ac:	0481 fa7c 	lapc	a0,41ff2c <_fini+0x1f79c>
  4004b0:	17c0      	lw	a3,0(a0)
  4004b2:	bb86      	bnezc	a3,4004ba <_init+0xf2>
  4004b4:	83e1 3012 	restore	16,ra
  4004b8:	1b97      	bc	400450 <_init+0x88>
  4004ba:	60eb fc0c 	lwpc	a3,4200cc <_Jv_RegisterClasses>
  4004be:	0001 
  4004c0:	9bf3      	beqzc	a3,4004b4 <_init+0xec>
  4004c2:	d8f0      	jalrc	a3
  4004c4:	1bef      	bc	4004b4 <_init+0xec>

unique_perm:; (char *data)
  4004c6:	1c52      	save	80,fp,ra
  4004c8:	83dd 8fb0 	addiu	fp,sp,-4016
  4004cc:	b483      	sw	a0,12(sp)
  4004ce:	b405      	sw	zero,20(sp)
  4004d0:	b406      	sw	zero,24(sp)
  4004d2:	b407      	sw	zero,28(sp)
  4004d4:	b408      	sw	zero,32(sp)
  4004d6:	b409      	sw	zero,36(sp)
  4004d8:	b40a      	sw	zero,40(sp)
  4004da:	b40b      	sw	zero,44(sp)
  4004dc:	b40c      	sw	zero,48(sp)
  4004de:	b40d      	sw	zero,52(sp)
  4004e0:	b40f      	sw	zero,60(sp)
; def i = sp+60
; def data = sp+12
  4004e2:	186c      	bc	400550 <_init+0x188>

loop:
; switch (data[i] - 'a')
  4004e4:	34ef      	lw	a3,60(sp)
  4004e6:	34c3      	lw	a2,12(sp)
  4004e8:	b3ee      	addu	a3,a2,a3
  4004ea:	5ff8      	lbu	a3,0(a3)
  4004ec:	80e7 8061 	addiu	a3,a3,-97
  4004f0:	c8ec d052 	bgeiuc	a3,26,400546 <_init+0x17e>
  4004f4:	04c0 02a0 	lapc	a2,400798 <_fini+0x8>
  4004f8:	537d      	lwxs	a2,a3(a2)
  4004fa:	4806 8000 	brsc	a2

; 'case 'z'
  4004fe:	34e5      	lw	a3,20(sp)
  400500:	90e9      	addiu	a3,a3,1
  400502:	b4e5      	sw	a3,20(sp)
  400504:	1844      	bc	40054a <_init+0x182>

; case 'x'
  400506:	34e6      	lw	a3,24(sp)
  400508:	90e9      	addiu	a3,a3,1
  40050a:	b4e6      	sw	a3,24(sp)
  40050c:	183c      	bc	40054a <_init+0x182>

; case 'c'
  40050e:	34e7      	lw	a3,28(sp)
  400510:	90e9      	addiu	a3,a3,1
  400512:	b4e7      	sw	a3,28(sp)
  400514:	1834      	bc	40054a <_init+0x182>

; case 'a'
  400516:	34e8      	lw	a3,32(sp)
  400518:	90e9      	addiu	a3,a3,1
  40051a:	b4e8      	sw	a3,32(sp)
  40051c:	182c      	bc	40054a <_init+0x182>

; casae 's'
  40051e:	34e9      	lw	a3,36(sp)
  400520:	90e9      	addiu	a3,a3,1
  400522:	b4e9      	sw	a3,36(sp)
  400524:	1824      	bc	40054a <_init+0x182>

; case 'd'
  400526:	34ea      	lw	a3,40(sp)
  400528:	90e9      	addiu	a3,a3,1
  40052a:	b4ea      	sw	a3,40(sp)
  40052c:	181c      	bc	40054a <_init+0x182>

; case 'q'
  40052e:	34eb      	lw	a3,44(sp)
  400530:	90e9      	addiu	a3,a3,1
  400532:	b4eb      	sw	a3,44(sp)
  400534:	1814      	bc	40054a <_init+0x182>

; case 'w'
  400536:	34ec      	lw	a3,48(sp)
  400538:	90e9      	addiu	a3,a3,1
  40053a:	b4ec      	sw	a3,48(sp)
  40053c:	180c      	bc	40054a <_init+0x182>

; case 'e'
  40053e:	34ed      	lw	a3,52(sp)
  400540:	90e9      	addiu	a3,a3,1
  400542:	b4ed      	sw	a3,52(sp)
  400544:	1804      	bc	40054a <_init+0x182>
; case 'b', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 't'
;      'u', 'v', 'y'
; default: 
; return 0
  400546:	10e0      	move	a3,zero
  400548:	1832      	bc	40057c <ret>
; i++
  40054a:	34ef      	lw	a3,60(sp)
  40054c:	90e9      	addiu	a3,a3,1
  40054e:	b4ef      	sw	a3,60(sp)

; while i < 9
loop_cond:
  400550:	34ef      	lw	a3,60(sp)
  400552:	c8f8 4f8f 	bltic	a3,9,4004e4 <loop>

; def ii = sp+56
; ii = 0
  400556:	b40e      	sw	zero,56(sp)
  400558:	181a      	bc	400574 <_init+0x1ac>
loop2:
; if nums[i] != 1; return 0
  40055a:	34ee      	lw	a3,56(sp)
  40055c:	33f2      	sll	a3,a3,2
  40055e:	7350      	addiu	a2,sp,64
  400560:	b3ee      	addu	a3,a2,a3
  400562:	a4e7 c0d4 	lw	a3,-44(a3)
  400566:	c8e0 0804 	beqic	a3,1,40056e <_init+0x1a6>
  40056a:	10e0      	move	a3,zero
  40056c:	180e      	bc	40057c <ret>
  40056e:	34ee      	lw	a3,56(sp)
  400570:	90e9      	addiu	a3,a3,1
  400572:	b4ee      	sw	a3,56(sp)
  400574:	34ee      	lw	a3,56(sp)

; while a3 < 9
loop2_cond:
  400576:	c8f8 4fe1 	bltic	a3,9,40055a <_init+0x192>
  40057a:	d381      	li	a3,1
ret:
  40057c:	1087      	move	a0,a3
  40057e:	1d52      	restore.jrc	80,fp,ra

verify_trans_rows:
  400580:	83c2 3030 	save	48,fp,ra
  400584:	83dd 8fd0 	addiu	fp,sp,-4048
  400588:	b403      	sw	zero,12(sp)
  40058a:	b404      	sw	zero,16(sp)
  40058c:	841d 1014 	sb	zero,20(sp)

; def buff = sp+12
; def row = sp+28
  400590:	b407      	sw	zero,28(sp)
  400592:	184c      	bc	4005e0 <_init+0x218>

outer_loop:
; def col = sp+24
  400594:	b406      	sw	zero,24(sp)
  400596:	182e      	bc	4005c6 <_init+0x1fe>

inner_loop:
; buff[col] = datamyst[trans[row * 9 + col]] 
  400598:	34c7      	lw	a2,28(sp)
  40059a:	10e6      	move	a3,a2
  40059c:	33f3      	sll	a3,a3,3
  40059e:	b37e      	addu	a3,a3,a2
  4005a0:	04c1 fab0 	lapc	a2,420054 <trans>
  4005a4:	b37c      	addu	a2,a3,a2
  4005a6:	34e6      	lw	a3,24(sp)
  4005a8:	b3ee      	addu	a3,a2,a3
  4005aa:	5ff8      	lbu	a3,0(a3)
  4005ac:	10c7      	move	a2,a3
  4005ae:	04e1 fa4e 	lapc	a3,420000 <datamyst>
  4005b2:	b3ee      	addu	a3,a2,a3
  4005b4:	5f78      	lbu	a2,0(a3)
  4005b6:	34e6      	lw	a3,24(sp)
  4005b8:	72c8      	addiu	a1,sp,32
  4005ba:	b3de      	addu	a3,a1,a3
  4005bc:	a4c7 88ec 	sb	a2,-20(a3)
  4005c0:	34e6      	lw	a3,24(sp)
  4005c2:	90e9      	addiu	a3,a3,1
  4005c4:	b4e6      	sw	a3,24(sp)

; while col < 9
  4005c6:	34e6      	lw	a3,24(sp)
  4005c8:	c8f8 4fcd 	bltic	a3,9,400598 <_init+0x1d0>

; unique_perm(buff)
  4005cc:	73c3      	addiu	a3,sp,12
  4005ce:	1087      	move	a0,a3
  4005d0:	3af5      	balc	4004c6 <unique_perm>
  4005d2:	10e4      	move	a3,a0
  4005d4:	bb84      	bnezc	a3,4005da <_init+0x212>
  4005d6:	10e0      	move	a3,zero
  4005d8:	180e      	bc	4005e8 <_init+0x220>
  4005da:	34e7      	lw	a3,28(sp)
  4005dc:	90e9      	addiu	a3,a3,1
  4005de:	b4e7      	sw	a3,28(sp)

; while row < 9
  4005e0:	34e7      	lw	a3,28(sp)
  4005e2:	c8f8 4faf 	bltic	a3,9,400594 <_init+0x1cc>

  4005e6:	d381      	li	a3,1
  4005e8:	1087      	move	a0,a3
  4005ea:	83c2 3033 	restore.jrc	48,fp,ra

verify_cols:
  4005ee:	83c2 3030 	save	48,fp,ra
  4005f2:	83dd 8fd0 	addiu	fp,sp,-4048
  4005f6:	b403      	sw	zero,12(sp)
  4005f8:	b404      	sw	zero,16(sp)
  4005fa:	841d 1014 	sb	zero,20(sp)

; def col = sp+28
; col = 0
  4005fe:	b407      	sw	zero,28(sp)
  400600:	1842      	bc	400644 <_init+0x27c>
outer_loop:
; def row = sp+28
  400602:	b406      	sw	zero,24(sp)
  400604:	1824      	bc	40062a <_init+0x262>
  400606:	34c6      	lw	a2,24(sp)
  400608:	10e6      	move	a3,a2
  40060a:	33f3      	sll	a3,a3,3
  40060c:	b37c      	addu	a2,a3,a2
  40060e:	34e7      	lw	a3,28(sp)
  400610:	b3ec      	addu	a2,a2,a3
  400612:	04e1 f9ea 	lapc	a3,420000 <datamyst>
  400616:	b3ee      	addu	a3,a2,a3
  400618:	5f78      	lbu	a2,0(a3)
  40061a:	34e6      	lw	a3,24(sp)
  40061c:	72c8      	addiu	a1,sp,32
  40061e:	b3de      	addu	a3,a1,a3
  400620:	a4c7 88ec 	sb	a2,-20(a3)
  400624:	34e6      	lw	a3,24(sp)
  400626:	90e9      	addiu	a3,a3,1
  400628:	b4e6      	sw	a3,24(sp)
; while row < 9
  40062a:	34e6      	lw	a3,24(sp)
  40062c:	c8f8 4fd7 	bltic	a3,9,400606 <_init+0x23e>
  400630:	73c3      	addiu	a3,sp,12
  400632:	1087      	move	a0,a3
  400634:	3a91      	balc	4004c6 <unique_perm>
  400636:	10e4      	move	a3,a0
  400638:	bb84      	bnezc	a3,40063e <_init+0x276>
  40063a:	10e0      	move	a3,zero
  40063c:	180e      	bc	40064c <_init+0x284>
  40063e:	34e7      	lw	a3,28(sp)
  400640:	90e9      	addiu	a3,a3,1
  400642:	b4e7      	sw	a3,28(sp)
; while col < 9
  400644:	34e7      	lw	a3,28(sp)
  400646:	c8f8 4fb9 	bltic	a3,9,400602 <_init+0x23a>
  40064a:	d381      	li	a3,1
  40064c:	1087      	move	a0,a3
  40064e:	83c2 3033 	restore.jrc	48,fp,ra

verify_rows:
  400652:	83c2 3030 	save	48,fp,ra
  400656:	83dd 8fd0 	addiu	fp,sp,-4048
  40065a:	b403      	sw	zero,12(sp)
  40065c:	b404      	sw	zero,16(sp)
  40065e:	841d 1014 	sb	zero,20(sp)

  400662:	b407      	sw	zero,28(sp)
  400664:	1842      	bc	4006a8 <_init+0x2e0>

  400666:	b406      	sw	zero,24(sp)
  400668:	1824      	bc	40068e <_init+0x2c6>

  40066a:	34c7      	lw	a2,28(sp)
  40066c:	10e6      	move	a3,a2
  40066e:	33f3      	sll	a3,a3,3
  400670:	b37c      	addu	a2,a3,a2
  400672:	34e6      	lw	a3,24(sp)
  400674:	b3ec      	addu	a2,a2,a3
  400676:	04e1 f986 	lapc	a3,420000 <datamyst>
  40067a:	b3ee      	addu	a3,a2,a3
  40067c:	5f78      	lbu	a2,0(a3)
  40067e:	34e6      	lw	a3,24(sp)
  400680:	72c8      	addiu	a1,sp,32
  400682:	b3de      	addu	a3,a1,a3
  400684:	a4c7 88ec 	sb	a2,-20(a3)
  400688:	34e6      	lw	a3,24(sp)
  40068a:	90e9      	addiu	a3,a3,1
  40068c:	b4e6      	sw	a3,24(sp)
  40068e:	34e6      	lw	a3,24(sp)
  400690:	c8f8 4fd7 	bltic	a3,9,40066a <_init+0x2a2>
  400694:	73c3      	addiu	a3,sp,12
  400696:	1087      	move	a0,a3
  400698:	3a2d      	balc	4004c6 <unique_perm>
  40069a:	10e4      	move	a3,a0
  40069c:	bb84      	bnezc	a3,4006a2 <_init+0x2da>
  40069e:	10e0      	move	a3,zero
  4006a0:	180e      	bc	4006b0 <_init+0x2e8>
  4006a2:	34e7      	lw	a3,28(sp)
  4006a4:	90e9      	addiu	a3,a3,1
  4006a6:	b4e7      	sw	a3,28(sp)
  4006a8:	34e7      	lw	a3,28(sp)
  4006aa:	c8f8 4fb9 	bltic	a3,9,400666 <_init+0x29e>
  4006ae:	d381      	li	a3,1
  4006b0:	1087      	move	a0,a3
  4006b2:	83c2 3033 	restore.jrc	48,fp,ra

verify:
  4006b6:	83c2 3010 	save	16,fp,ra
  4006ba:	83dd 8ff0 	addiu	fp,sp,-4080
  4006be:	3ac1      	balc	400580 <verify_trans_rows>
  4006c0:	10e4      	move	a3,a0
  4006c2:	bb84      	bnezc	a3,4006c8 <_init+0x300>
  4006c4:	10e0      	move	a3,zero
  4006c6:	1816      	bc	4006de <_init+0x316>

  4006c8:	3b25      	balc	4005ee <verify_cols>
  4006ca:	10e4      	move	a3,a0
  4006cc:	bb84      	bnezc	a3,4006d2 <_init+0x30a>
  4006ce:	10e0      	move	a3,zero
  4006d0:	180c      	bc	4006de <_init+0x316>
  4006d2:	3b7f      	balc	400652 <verify_rows>
  4006d4:	10e4      	move	a3,a0
  4006d6:	bb84      	bnezc	a3,4006dc <_init+0x314>
  4006d8:	10e0      	move	a3,zero
  4006da:	1802      	bc	4006de <_init+0x316>
  4006dc:	d381      	li	a3,1
  4006de:	1087      	move	a0,a3
  4006e0:	83c2 3013 	restore.jrc	16,fp,ra

main:
  4006e4:	83c3 3084 	save	128,fp,ra,gp
  4006e8:	83dd 8f80 	addiu	fp,sp,-3968
  4006ec:	0781 f9bc 	lapc	gp,4200ac <_fini+0x1f91c>
  4006f0:	73c3      	addiu	a3,sp,12

  ; memset(buff, 0, 90)
  4006f2:	d35a      	li	a2,90
  4006f4:	bc67      	movep	a0,a1,a3,zero
  4006f6:	40e0 0032 	lw	a3,48(gp) ; memset
  4006fa:	d8f0      	jalrc	a3

  ; read(0, buff, 62)
  4006fc:	73c3      	addiu	a3,sp,12
  4006fe:	d33e      	li	a2,62
  400700:	bce3      	movep	a0,a1,zero,a3
  400702:	40e0 0026 	lw	a3,36(gp) ; read
  400706:	d8f0      	jalrc	a3

  ; if buff[-1] != '}' goto wrong2
  400708:	84fd 2049 	lbu	a3,73(sp)
  40070c:	c8f3 e86c 	bneic	a3,125,40077c <wrong2>

  ; if strncmp(buff, "flag{", 5)
  400710:	73c3      	addiu	a3,sp,12
  400712:	d305      	li	a2,5
  400714:	04a0 00e8 	lapc	a1,400800 <_fini+0x70>
  400718:	1087      	move	a0,a3
  40071a:	40e0 002a 	lw	a3,40(gp) ; strncmp
  40071e:	d8f0      	jalrc	a3
  400720:	10e4      	move	a3,a0
  400722:	bbd8      	bnezc	a3,40077c <wrong2>

  ; def i = sp + 108
  ; def j = sp + 104
  ; def buff2 = sp+112
  ; i = 0
  ; j = 5
  400724:	b41b      	sw	zero,108(sp)
  400726:	d385      	li	a3,5
  400728:	b4fa      	sw	a3,104(sp)
  40072a:	182c      	bc	400758 <loop_cond>

  ; i++
inner_loop:
  40072c:	34fb      	lw	a3,108(sp)
  40072e:	90e9      	addiu	a3,a3,1
  400730:	b4fb      	sw	a3,108(sp)

loop:
  ; while datamyst[i] != 0
  400732:	04c1 f8ca 	lapc	a2,420000 <datamyst>
  400736:	34fb      	lw	a3,108(sp)
  400738:	b3ee      	addu	a3,a2,a3
  40073a:	5ff8      	lbu	a3,0(a3)
  40073c:	bbef      	bnezc	a3,40072c <inner_loop>

  ; datamyst[i] = buff[j]
  40073e:	34fa      	lw	a3,104(sp)
  400740:	735c      	addiu	a2,sp,112
  400742:	b3ee      	addu	a3,a2,a3
  400744:	a4c7 909c 	lbu	a2,-100(a3)
  400748:	04a1 f8b4 	lapc	a1,420000 <datamyst>
  40074c:	34fb      	lw	a3,108(sp)
  40074e:	b3de      	addu	a3,a1,a3
  400750:	5f74      	sb	a2,0(a3)

  ; j++
  400752:	34fa      	lw	a3,104(sp)
  400754:	90e9      	addiu	a3,a3,1
  400756:	b4fa      	sw	a3,104(sp)
  ; while j < 61
loop_cond:
  400758:	34fa      	lw	a3,104(sp)
  40075a:	c8f9 efd5 	bltic	a3,61,400732 <loop>

  ; call verify
  40075e:	3b57      	balc	4006b6 <verify>
  400760:	10e4      	move	a3,a0
  400762:	9b8c      	beqzc	a3,400770 <wrong>

  400764:	0480 00a0 	lapc	a0,400808 <_fini+0x78> ; right
  400768:	40e0 002e 	lw	a3,44(gp) ; puts
  40076c:	d8f0      	jalrc	a3
  40076e:	1816      	bc	400786 <_init+0x3be>
wrong:
  400770:	0480 009c 	lapc	a0,400810 <_fini+0x80> ; wrong
  400774:	40e0 002e 	lw	a3,44(gp) ; puts
  400778:	d8f0      	jalrc	a3
  40077a:	180a      	bc	400786 <_init+0x3be>
wrong2:
  40077c:	0480 0090 	lapc	a0,400810 <_fini+0x80> ; wrong
  400780:	40e0 002e 	lw	a3,44(gp) ; puts
  400784:	d8f0      	jalrc	a3
  400786:	10e0      	move	a3,zero
  400788:	1087      	move	a0,a3
  40078a:	83c3 3087 	restore.jrc	128,fp,ra,gp

Disassembly of section .fini:

00400790 <_fini>:
  400790:	83e2 3024 	save	32,ra,gp
  400794:	83e2 3027 	restore.jrc	32,ra,gp
