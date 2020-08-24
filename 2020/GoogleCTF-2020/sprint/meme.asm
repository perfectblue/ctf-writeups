BITS 64
push rsp
mov rbp, rsp
mov rdi, 0x4000000
xor rsi, rsi
xor r9, r9
xor r10, r10
xor r11, r11
xor r12, r12
xor r13, r13
xor r14, r14
xor r15, r15
loc_0:
xor eax, eax
add rax, 28672
mov r8, rax
mov rbx, 0
nop
loc_38:
xor eax, eax
add rax, r8
mov rdi, rax
mov rbx, 38
nop
loc_74:
xor eax, eax
add rax, 1
mov [rdi], rax
mov rbx, 74
nop
loc_108:
xor eax, eax
add rax, r8
add rax, 2
mov rdi, rax
mov rbx, 108
nop
loc_149:
xor eax, eax
add rax, 1
mov [rdi], rax
mov rbx, 149
nop
loc_183:
xor eax, eax
add rax, 2
mov r9, rax
mov rbx, 183
nop
loc_218:
xor eax, eax
add rax, r9
add rax, r9
mov r12, rax
mov rbx, 218
nop
loc_264:
xor eax, eax
add rax, r12
add rax, 28672
mov rdi, rax
mov rbx, 264
nop
loc_310:
xor eax, eax
add rax, [rdi]
mov r11, rax
mov rbx, 310
nop
loc_347:
test r11, r11
jnz loc_804
jmp loc_384
loc_384:
xor eax, eax
add rax, r9
add rax, r9
mov r10, rax
mov rbx, 384
nop
loc_430:
xor eax, eax
sub rax, 17
mov rdi, rax
mov rbx, 430
nop
loc_468:
xor eax, eax
add rax, r10
mov [rdi], rax
mov rbx, 468
nop
loc_505:
xor eax, eax
sub rax, 16
mov rdi, rax
mov rbx, 505
nop
loc_543:
xor eax, eax
add rax, [rdi]
mov r11, rax
mov rbx, 543
nop
loc_580:
test r11, r11
jnz loc_804
jmp loc_617
loc_617:
xor eax, eax
add rax, r10
add rax, r10
mov r12, rax
mov rbx, 617
nop
loc_663:
xor eax, eax
add rax, r12
add rax, 28672
mov rdi, rax
mov rbx, 663
nop
loc_709:
xor eax, eax
add rax, 1
mov [rdi], rax
mov rbx, 709
nop
loc_743:
xor eax, eax
add rax, r10
add rax, r9
mov r10, rax
mov rbx, 743
nop
loc_789:
jmp loc_430
mov rbx, 789
nop
loc_804:
xor eax, eax
add rax, r9
add rax, 1
mov r9, rax
mov rbx, 804
nop
loc_847:
test r9, r9
jnz loc_218
jmp loc_884
loc_884:
xor eax, eax
sub rax, 8192
mov r8, rax
mov rbx, 884
nop
loc_922:
xor eax, eax
mov r9, rax
mov rbx, 922
nop
loc_957:
xor eax, eax
add rax, r8
mov rdi, rax
mov rbx, 957
nop
loc_993:
xor eax, eax
add rax, [rdi]
mov r10, rax
mov rbx, 993
nop
loc_1030:
test r10, r10
jnz loc_1082
jmp loc_1067
loc_1067:
jmp loc_1185
mov rbx, 1067
nop
loc_1082:
xor eax, eax
add rax, r9
sub rax, 1
mov r9, rax
mov rbx, 1082
nop
loc_1129:
xor eax, eax
add rax, r8
add rax, 1
mov r8, rax
mov rbx, 1129
nop
loc_1170:
jmp loc_957
mov rbx, 1170
nop
loc_1185:
xor eax, eax
add rax, r9
add rax, 254
mov r12, rax
mov rbx, 1185
nop
loc_1232:
test r12, r12
jnz loc_1284
jmp loc_1269
loc_1269:
jmp loc_1334
mov rbx, 1269
nop
loc_1284:
xor eax, eax
add rax, 5
mov r15, rax
mov rbx, 1284
nop
loc_1319:
jmp loc_5081
mov rbx, 1319
nop
loc_1334:
xor eax, eax
mov r8, rax
mov rbx, 1334
nop
loc_1368:
xor eax, eax
mov r9, rax
mov rbx, 1368
nop
loc_1403:
xor eax, eax
sub rax, 3840
mov rdi, rax
mov rbx, 1403
nop
loc_1441:
xor eax, eax
add rax, [rdi]
mov r10, rax
mov rbx, 1441
nop
loc_1478:
xor eax, eax
add rax, 1
mov r11, rax
mov rbx, 1478
nop
loc_1513:
xor eax, eax
mov r15, rax
mov rbx, 1513
nop
loc_1548:
xor eax, eax
add rax, r8
sub rax, 8192
mov rdi, rax
mov rbx, 1548
nop
loc_1593:
xor eax, eax
add rax, [rdi]
mov r12, rax
mov rbx, 1593
nop
loc_1630:
test r12, r12
jnz loc_1682
jmp loc_1667
loc_1667:
jmp loc_3479
mov rbx, 1667
nop
loc_1682:
xor eax, eax
add rax, r8
add rax, 1
mov r8, rax
mov rbx, 1682
nop
loc_1723:
xor eax, eax
add rax, r12
sub rax, 117
mov r13, rax
mov rbx, 1723
nop
loc_1770:
test r13, r13
jnz loc_1861
jmp loc_1807
loc_1807:
xor eax, eax
sub rax, 16
mov r12, rax
mov rbx, 1807
nop
loc_1846:
jmp loc_2373
mov rbx, 1846
nop
loc_1861:
xor eax, eax
add rax, r12
sub rax, 114
mov r13, rax
mov rbx, 1861
nop
loc_1908:
test r13, r13
jnz loc_1995
jmp loc_1945
loc_1945:
xor eax, eax
add rax, 1
mov r12, rax
mov rbx, 1945
nop
loc_1980:
jmp loc_2373
mov rbx, 1980
nop
loc_1995:
xor eax, eax
add rax, r12
sub rax, 100
mov r13, rax
mov rbx, 1995
nop
loc_2042:
test r13, r13
jnz loc_2130
jmp loc_2079
loc_2079:
xor eax, eax
add rax, 16
mov r12, rax
mov rbx, 2079
nop
loc_2115:
jmp loc_2373
mov rbx, 2115
nop
loc_2130:
xor eax, eax
add rax, r12
sub rax, 108
mov r13, rax
mov rbx, 2130
nop
loc_2177:
test r13, r13
jnz loc_2268
jmp loc_2214
loc_2214:
xor eax, eax
sub rax, 1
mov r12, rax
mov rbx, 2214
nop
loc_2253:
jmp loc_2373
mov rbx, 2253
nop
loc_2268:
xor eax, eax
mov r11, rax
mov rbx, 2268
nop
loc_2303:
xor eax, eax
mov r12, rax
mov rbx, 2303
nop
loc_2338:
xor eax, eax
add rax, 1
mov r15, rax
mov rbx, 2338
nop
loc_2373:
xor eax, eax
add rax, r10
add rax, r12
mov r10, rax
mov rbx, 2373
nop
loc_2419:
xor eax, eax
sub rax, 17
mov rdi, rax
mov rbx, 2419
nop
loc_2457:
xor eax, eax
add rax, r10
mov [rdi], rax
mov rbx, 2457
nop
loc_2494:
xor eax, eax
sub rax, 16
mov rdi, rax
mov rbx, 2494
nop
loc_2532:
xor eax, eax
add rax, [rdi]
mov r12, rax
mov rbx, 2532
nop
loc_2569:
test r12, r12
jnz loc_3429
jmp loc_2606
loc_2606:
xor eax, eax
add rax, r10
sub rax, 4096
mov rdi, rax
mov rbx, 2606
nop
loc_2652:
xor eax, eax
add rax, [rdi]
mov r12, rax
mov rbx, 2652
nop
loc_2689:
xor eax, eax
sub rax, 17
mov rdi, rax
mov rbx, 2689
nop
loc_2727:
xor eax, eax
add rax, r12
mov [rdi], rax
mov rbx, 2727
nop
loc_2764:
xor eax, eax
sub rax, 16
mov rdi, rax
mov rbx, 2764
nop
loc_2802:
xor eax, eax
mov [rdi], rax
mov rbx, 2802
nop
loc_2836:
xor eax, eax
sub rax, 17
mov rdi, rax
mov rbx, 2836
nop
loc_2874:
xor eax, eax
add rax, [rdi]
mov r12, rax
mov rbx, 2874
nop
loc_2911:
xor eax, eax
add rax, r12
add rax, r12
mov r12, rax
mov rbx, 2911
nop
loc_2957:
xor eax, eax
add rax, r12
add rax, 28672
mov rdi, rax
mov rbx, 2957
nop
loc_3003:
xor eax, eax
add rax, [rdi]
mov r12, rax
mov rbx, 3003
nop
loc_3040:
test r12, r12
jnz loc_3344
jmp loc_3077
loc_3077:
xor eax, eax
add rax, r9
add rax, 1
mov r12, rax
mov rbx, 3077
nop
loc_3120:
xor eax, eax
add rax, r12
sub rax, 3838
mov rdi, rax
mov rbx, 3120
nop
loc_3166:
xor eax, eax
add rax, [rdi]
mov r12, rax
mov rbx, 3166
nop
loc_3203:
xor eax, eax
add rax, r12
add rax, r10
mov r12, rax
mov rbx, 3203
nop
loc_3249:
test r12, r12
jnz loc_3329
jmp loc_3286
loc_3286:
xor eax, eax
add rax, r9
add rax, 1
mov r9, rax
mov rbx, 3286
nop
loc_3329:
jmp loc_1548
mov rbx, 3329
nop
loc_3344:
xor eax, eax
mov r11, rax
mov rbx, 3344
nop
loc_3379:
xor eax, eax
add rax, 2
mov r15, rax
mov rbx, 3379
nop
loc_3414:
jmp loc_1548
mov rbx, 3414
nop
loc_3429:
xor eax, eax
add rax, 4
mov r15, rax
mov rbx, 3429
nop
loc_3464:
jmp loc_end;
mov rbx, 3464
nop
loc_3479:
test r11, r11
jnz loc_3531
jmp loc_3516
loc_3516:
jmp loc_5081
mov rbx, 3516
nop
loc_3531:
xor eax, eax
add rax, r9
sub rax, 9
mov r12, rax
mov rbx, 3531
nop
loc_3578:
test r12, r12
jnz loc_3630
jmp loc_3615
loc_3615:
jmp loc_3680
mov rbx, 3615
nop
loc_3630:
xor eax, eax
add rax, 3
mov r15, rax
mov rbx, 3630
nop
loc_3665:
jmp loc_5081
mov rbx, 3665
nop
loc_3680:
xor eax, eax
mov r8, rax
mov rbx, 3680
nop
loc_3714:
xor eax, eax
mov r9, rax
mov rbx, 3714
nop
loc_3749:
xor eax, eax
add rax, r8
sub rax, 39
mov r10, rax
mov rbx, 3749
nop
loc_3795:
test r10, r10
jnz loc_3847
jmp loc_3832
loc_3832:
jmp loc_4987
mov rbx, 3832
nop
loc_3847:
xor eax, eax
add rax, 4
mov r11, rax
mov rbx, 3847
nop
loc_3882:
xor eax, eax
mov r10, rax
mov rbx, 3882
nop
loc_3917:
xor eax, eax
add rax, r10
add rax, r10
mov r10, rax
mov rbx, 3917
nop
loc_3963:
xor eax, eax
add rax, r10
add rax, r10
mov r10, rax
mov rbx, 3963
nop
loc_4009:
xor eax, eax
add rax, r9
sub rax, 8192
mov rdi, rax
mov rbx, 4009
nop
loc_4055:
xor eax, eax
add rax, [rdi]
mov r12, rax
mov rbx, 4055
nop
loc_4092:
xor eax, eax
add rax, r12
sub rax, 117
mov r13, rax
mov rbx, 4092
nop
loc_4139:
test r13, r13
jnz loc_4191
jmp loc_4176
loc_4176:
jmp loc_4632
mov rbx, 4176
nop
loc_4191:
xor eax, eax
add rax, r12
sub rax, 114
mov r13, rax
mov rbx, 4191
nop
loc_4238:
test r13, r13
jnz loc_4333
jmp loc_4275
loc_4275:
xor eax, eax
add rax, r10
add rax, 1
mov r10, rax
mov rbx, 4275
nop
loc_4318:
jmp loc_4632
mov rbx, 4318
nop
loc_4333:
xor eax, eax
add rax, r12
sub rax, 100
mov r13, rax
mov rbx, 4333
nop
loc_4380:
test r13, r13
jnz loc_4475
jmp loc_4417
loc_4417:
xor eax, eax
add rax, r10
add rax, 2
mov r10, rax
mov rbx, 4417
nop
loc_4460:
jmp loc_4632
mov rbx, 4460
nop
loc_4475:
xor eax, eax
add rax, r12
sub rax, 108
mov r13, rax
mov rbx, 4475
nop
loc_4522:
test r13, r13
jnz loc_4617
jmp loc_4559
loc_4559:
xor eax, eax
add rax, r10
add rax, 3
mov r10, rax
mov rbx, 4559
nop
loc_4602:
jmp loc_4632
mov rbx, 4602
nop
loc_4617:
jmp loc_5081
mov rbx, 4617
nop
loc_4632:
xor eax, eax
add rax, r9
add rax, 1
mov r9, rax
mov rbx, 4632
nop
loc_4675:
xor eax, eax
add rax, r11
sub rax, 1
mov r11, rax
mov rbx, 4675
nop
loc_4722:
test r11, r11
jnz loc_3917
jmp loc_4759
loc_4759:
xor eax, eax
add rax, r8
sub rax, 3828
mov rdi, rax
mov rbx, 4759
nop
loc_4804:
xor eax, eax
add rax, [rdi]
mov r11, rax
mov rbx, 4804
nop
loc_4841:
xor eax, eax
add rax, r8
sub rax, 6144
mov rdi, rax
mov rbx, 4841
nop
loc_4886:
xor eax, eax
add rax, r11
add rax, r10
mov [rdi], rax
mov rbx, 4886
nop
loc_4931:
xor eax, eax
add rax, r8
add rax, 1
mov r8, rax
mov rbx, 4931
nop
loc_4972:
jmp loc_3749
mov rbx, 4972
nop
loc_4987:
xor eax, eax
add rax, r8
sub rax, 6144
mov rdi, rax
mov rbx, 4987
nop
loc_5032:
xor eax, eax
mov [rdi], rax
mov rbx, 5032
nop
loc_5066:
jmp loc_end;
mov rbx, 5066
nop
loc_5081:
xor eax, eax
sub rax, 6144
mov rdi, rax
mov rbx, 5081
nop
loc_5119:
xor eax, eax
mov [rdi], rax
mov rbx, 5119
nop
loc_5153:
jmp loc_end;
mov rbx, 5153
nop
loc_end:
leave
ret