.text:0040141E 028 B8 04 00 00 00                    mov     eax, 4
.text:00401423 028 C1 E0 00                          shl     eax, 0
.text:00401426 028 8B 4D 0C                          mov     ecx, [ebp+argv]
.text:00401429 028 8B 14 01                          mov     edx, [ecx+eax]
.text:0040142C 028 89 55 F0                          mov     [ebp+var_10], edx
.text:0040142F 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401432 028 99                                cdq
.text:00401433 028 52                                push    edx
.text:00401434 02C 50                                push    eax
.text:00401435 030 6A 00                             push    0
.text:00401437 034 68 C4 00 00 00                    push    0C4h ; 'Ä'
.text:0040143C 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040143F 038 99                                cdq
.text:00401440 038 52                                push    edx
.text:00401441 03C 50                                push    eax
.text:00401442 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401445 040 99                                cdq
.text:00401446 040 52                                push    edx
.text:00401447 044 50                                push    eax
.text:00401448 048 FF 15 4C 54 40 00                 call    dword_40544C
.text:0040144E 048 83 C4 20                          add     esp, 20h
.text:00401451 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401454 028 83 C0 01                          add     eax, 1
.text:00401457 028 89 45 F0                          mov     [ebp+var_10], eax
.text:0040145A 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:0040145D 028 99                                cdq
.text:0040145E 028 52                                push    edx
.text:0040145F 02C 50                                push    eax
.text:00401460 030 6A 00                             push    0
.text:00401462 034 6A 16                             push    16h
.text:00401464 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401467 038 99                                cdq
.text:00401468 038 52                                push    edx
.text:00401469 03C 50                                push    eax
.text:0040146A 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040146D 040 99                                cdq
.text:0040146E 040 52                                push    edx
.text:0040146F 044 50                                push    eax
.text:00401470 048 FF 15 A8 53 40 00                 call    dword_4053A8
.text:00401476 048 83 C4 20                          add     esp, 20h
.text:00401479 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:0040147C 028 83 C1 01                          add     ecx, 1
.text:0040147F 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:00401482 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401485 028 99                                cdq
.text:00401486 028 52                                push    edx
.text:00401487 02C 50                                push    eax
.text:00401488 030 6A 00                             push    0
.text:0040148A 034 68 8E 00 00 00                    push    8Eh ; 'Ž'
.text:0040148F 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401492 038 99                                cdq
.text:00401493 038 52                                push    edx
.text:00401494 03C 50                                push    eax
.text:00401495 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401498 040 99                                cdq
.text:00401499 040 52                                push    edx
.text:0040149A 044 50                                push    eax
.text:0040149B 048 FF 15 B4 53 40 00                 call    dword_4053B4
.text:004014A1 048 83 C4 20                          add     esp, 20h
.text:004014A4 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:004014A7 028 83 C2 01                          add     edx, 1
.text:004014AA 028 89 55 F0                          mov     [ebp+var_10], edx
.text:004014AD 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004014B0 028 99                                cdq
.text:004014B1 028 52                                push    edx
.text:004014B2 02C 50                                push    eax
.text:004014B3 030 6A 00                             push    0
.text:004014B5 034 6A 77                             push    77h ; 'w'
.text:004014B7 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004014BA 038 99                                cdq
.text:004014BB 038 52                                push    edx
.text:004014BC 03C 50                                push    eax
.text:004014BD 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004014C0 040 99                                cdq
.text:004014C1 040 52                                push    edx
.text:004014C2 044 50                                push    eax
.text:004014C3 048 FF 15 F0 53 40 00                 call    dword_4053F0
.text:004014C9 048 83 C4 20                          add     esp, 20h
.text:004014CC 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004014CF 028 83 C0 01                          add     eax, 1
.text:004014D2 028 89 45 F0                          mov     [ebp+var_10], eax
.text:004014D5 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004014D8 028 99                                cdq
.text:004014D9 028 52                                push    edx
.text:004014DA 02C 50                                push    eax
.text:004014DB 030 6A 00                             push    0
.text:004014DD 034 6A 05                             push    5
.text:004014DF 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004014E2 038 99                                cdq
.text:004014E3 038 52                                push    edx
.text:004014E4 03C 50                                push    eax
.text:004014E5 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004014E8 040 99                                cdq
.text:004014E9 040 52                                push    edx
.text:004014EA 044 50                                push    eax
.text:004014EB 048 FF 15 48 54 40 00                 call    dword_405448
.text:004014F1 048 83 C4 20                          add     esp, 20h
.text:004014F4 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:004014F7 028 83 C1 01                          add     ecx, 1
.text:004014FA 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:004014FD 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401500 028 99                                cdq
.text:00401501 028 52                                push    edx
.text:00401502 02C 50                                push    eax
.text:00401503 030 6A 00                             push    0
.text:00401505 034 68 B9 00 00 00                    push    0B9h ; '¹'
.text:0040150A 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040150D 038 99                                cdq
.text:0040150E 038 52                                push    edx
.text:0040150F 03C 50                                push    eax
.text:00401510 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401513 040 99                                cdq
.text:00401514 040 52                                push    edx
.text:00401515 044 50                                push    eax
.text:00401516 048 FF 15 FC 53 40 00                 call    dword_4053FC
.text:0040151C 048 83 C4 20                          add     esp, 20h
.text:0040151F 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:00401522 028 83 C2 01                          add     edx, 1
.text:00401525 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401528 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:0040152B 028 99                                cdq
.text:0040152C 028 52                                push    edx
.text:0040152D 02C 50                                push    eax
.text:0040152E 030 6A 00                             push    0
.text:00401530 034 6A 0D                             push    0Dh
.text:00401532 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401535 038 99                                cdq
.text:00401536 038 52                                push    edx
.text:00401537 03C 50                                push    eax
.text:00401538 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040153B 040 99                                cdq
.text:0040153C 040 52                                push    edx
.text:0040153D 044 50                                push    eax
.text:0040153E 048 FF 15 00 54 40 00                 call    dword_405400
.text:00401544 048 83 C4 20                          add     esp, 20h
.text:00401547 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040154A 028 83 C0 01                          add     eax, 1
.text:0040154D 028 89 45 F0                          mov     [ebp+var_10], eax
.text:00401550 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401553 028 99                                cdq
.text:00401554 028 52                                push    edx
.text:00401555 02C 50                                push    eax
.text:00401556 030 6A 00                             push    0
.text:00401558 034 6A 6B                             push    6Bh ; 'k'
.text:0040155A 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040155D 038 99                                cdq
.text:0040155E 038 52                                push    edx
.text:0040155F 03C 50                                push    eax
.text:00401560 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401563 040 99                                cdq
.text:00401564 040 52                                push    edx
.text:00401565 044 50                                push    eax
.text:00401566 048 FF 15 10 54 40 00                 call    dword_405410
.text:0040156C 048 83 C4 20                          add     esp, 20h
.text:0040156F 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:00401572 028 83 C1 01                          add     ecx, 1
.text:00401575 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:00401578 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:0040157B 028 99                                cdq
.text:0040157C 028 52                                push    edx
.text:0040157D 02C 50                                push    eax
.text:0040157E 030 6A 00                             push    0
.text:00401580 034 6A 24                             push    24h ; '$'
.text:00401582 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401585 038 99                                cdq
.text:00401586 038 52                                push    edx
.text:00401587 03C 50                                push    eax
.text:00401588 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040158B 040 99                                cdq
.text:0040158C 040 52                                push    edx
.text:0040158D 044 50                                push    eax
.text:0040158E 048 FF 15 F8 53 40 00                 call    dword_4053F8
.text:00401594 048 83 C4 20                          add     esp, 20h
.text:00401597 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:0040159A 028 83 C2 01                          add     edx, 1
.text:0040159D 028 89 55 F0                          mov     [ebp+var_10], edx
.text:004015A0 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004015A3 028 99                                cdq
.text:004015A4 028 52                                push    edx
.text:004015A5 02C 50                                push    eax
.text:004015A6 030 6A 00                             push    0
.text:004015A8 034 6A 55                             push    55h ; 'U'
.text:004015AA 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004015AD 038 99                                cdq
.text:004015AE 038 52                                push    edx
.text:004015AF 03C 50                                push    eax
.text:004015B0 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004015B3 040 99                                cdq
.text:004015B4 040 52                                push    edx
.text:004015B5 044 50                                push    eax
.text:004015B6 048 FF 15 30 54 40 00                 call    dword_405430
.text:004015BC 048 83 C4 20                          add     esp, 20h
.text:004015BF 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004015C2 028 83 C0 01                          add     eax, 1
.text:004015C5 028 89 45 F0                          mov     [ebp+var_10], eax
.text:004015C8 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004015CB 028 99                                cdq
.text:004015CC 028 52                                push    edx
.text:004015CD 02C 50                                push    eax
.text:004015CE 030 6A 00                             push    0
.text:004015D0 034 6A 12                             push    12h
.text:004015D2 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004015D5 038 99                                cdq
.text:004015D6 038 52                                push    edx
.text:004015D7 03C 50                                push    eax
.text:004015D8 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004015DB 040 99                                cdq
.text:004015DC 040 52                                push    edx
.text:004015DD 044 50                                push    eax
.text:004015DE 048 FF 15 D0 53 40 00                 call    dword_4053D0
.text:004015E4 048 83 C4 20                          add     esp, 20h
.text:004015E7 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:004015EA 028 83 C1 01                          add     ecx, 1
.text:004015ED 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:004015F0 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004015F3 028 99                                cdq
.text:004015F4 028 52                                push    edx
.text:004015F5 02C 50                                push    eax
.text:004015F6 030 6A 00                             push    0
.text:004015F8 034 6A 35                             push    35h ; '5'
.text:004015FA 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004015FD 038 99                                cdq
.text:004015FE 038 52                                push    edx
.text:004015FF 03C 50                                push    eax
.text:00401600 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401603 040 99                                cdq
.text:00401604 040 52                                push    edx
.text:00401605 044 50                                push    eax
.text:00401606 048 FF 15 34 54 40 00                 call    dword_405434
.text:0040160C 048 83 C4 20                          add     esp, 20h
.text:0040160F 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:00401612 028 83 C2 01                          add     edx, 1
.text:00401615 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401618 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:0040161B 028 99                                cdq
.text:0040161C 028 52                                push    edx
.text:0040161D 02C 50                                push    eax
.text:0040161E 030 6A 00                             push    0
.text:00401620 034 6A 76                             push    76h ; 'v'
.text:00401622 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401625 038 99                                cdq
.text:00401626 038 52                                push    edx
.text:00401627 03C 50                                push    eax
.text:00401628 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040162B 040 99                                cdq
.text:0040162C 040 52                                push    edx
.text:0040162D 044 50                                push    eax
.text:0040162E 048 FF 15 5C 54 40 00                 call    dword_40545C
.text:00401634 048 83 C4 20                          add     esp, 20h
.text:00401637 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040163A 028 83 C0 01                          add     eax, 1
.text:0040163D 028 89 45 F0                          mov     [ebp+var_10], eax
.text:00401640 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401643 028 99                                cdq
.text:00401644 028 52                                push    edx
.text:00401645 02C 50                                push    eax
.text:00401646 030 6A 00                             push    0
.text:00401648 034 68 E7 00 00 00                    push    0E7h ; 'ç'
.text:0040164D 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401650 038 99                                cdq
.text:00401651 038 52                                push    edx
.text:00401652 03C 50                                push    eax
.text:00401653 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401656 040 99                                cdq
.text:00401657 040 52                                push    edx
.text:00401658 044 50                                push    eax
.text:00401659 048 FF 15 54 54 40 00                 call    dword_405454
.text:0040165F 048 83 C4 20                          add     esp, 20h
.text:00401662 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:00401665 028 83 C1 01                          add     ecx, 1
.text:00401668 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:0040166B 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:0040166E 028 99                                cdq
.text:0040166F 028 52                                push    edx
.text:00401670 02C 50                                push    eax
.text:00401671 030 6A 00                             push    0
.text:00401673 034 68 FB 00 00 00                    push    0FBh ; 'û'
.text:00401678 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040167B 038 99                                cdq
.text:0040167C 038 52                                push    edx
.text:0040167D 03C 50                                push    eax
.text:0040167E 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401681 040 99                                cdq
.text:00401682 040 52                                push    edx
.text:00401683 044 50                                push    eax
.text:00401684 048 FF 15 C0 53 40 00                 call    dword_4053C0
.text:0040168A 048 83 C4 20                          add     esp, 20h
.text:0040168D 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:00401690 028 83 C2 01                          add     edx, 1
.text:00401693 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401696 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401699 028 99                                cdq
.text:0040169A 028 52                                push    edx
.text:0040169B 02C 50                                push    eax
.text:0040169C 030 6A 00                             push    0
.text:0040169E 034 68 A0 00 00 00                    push    0A0h ; ' '
.text:004016A3 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004016A6 038 99                                cdq
.text:004016A7 038 52                                push    edx
.text:004016A8 03C 50                                push    eax
.text:004016A9 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004016AC 040 99                                cdq
.text:004016AD 040 52                                push    edx
.text:004016AE 044 50                                push    eax
.text:004016AF 048 FF 15 E4 53 40 00                 call    dword_4053E4
.text:004016B5 048 83 C4 20                          add     esp, 20h
.text:004016B8 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004016BB 028 83 C0 01                          add     eax, 1
.text:004016BE 028 89 45 F0                          mov     [ebp+var_10], eax
.text:004016C1 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004016C4 028 99                                cdq
.text:004016C5 028 52                                push    edx
.text:004016C6 02C 50                                push    eax
.text:004016C7 030 6A 00                             push    0
.text:004016C9 034 68 DA 00 00 00                    push    0DAh ; 'Ú'
.text:004016CE 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004016D1 038 99                                cdq
.text:004016D2 038 52                                push    edx
.text:004016D3 03C 50                                push    eax
.text:004016D4 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004016D7 040 99                                cdq
.text:004016D8 040 52                                push    edx
.text:004016D9 044 50                                push    eax
.text:004016DA 048 FF 15 C4 53 40 00                 call    dword_4053C4
.text:004016E0 048 83 C4 20                          add     esp, 20h
.text:004016E3 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:004016E6 028 83 C1 01                          add     ecx, 1
.text:004016E9 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:004016EC 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004016EF 028 99                                cdq
.text:004016F0 028 52                                push    edx
.text:004016F1 02C 50                                push    eax
.text:004016F2 030 6A 00                             push    0
.text:004016F4 034 6A 34                             push    34h ; '4'
.text:004016F6 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004016F9 038 99                                cdq
.text:004016FA 038 52                                push    edx
.text:004016FB 03C 50                                push    eax
.text:004016FC 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004016FF 040 99                                cdq
.text:00401700 040 52                                push    edx
.text:00401701 044 50                                push    eax
.text:00401702 048 FF 15 40 54 40 00                 call    dword_405440
.text:00401708 048 83 C4 20                          add     esp, 20h
.text:0040170B 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:0040170E 028 83 C2 01                          add     edx, 1
.text:00401711 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401714 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401717 028 99                                cdq
.text:00401718 028 52                                push    edx
.text:00401719 02C 50                                push    eax
.text:0040171A 030 6A 00                             push    0
.text:0040171C 034 68 84 00 00 00                    push    84h ; '„'
.text:00401721 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401724 038 99                                cdq
.text:00401725 038 52                                push    edx
.text:00401726 03C 50                                push    eax
.text:00401727 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040172A 040 99                                cdq
.text:0040172B 040 52                                push    edx
.text:0040172C 044 50                                push    eax
.text:0040172D 048 FF 15 BC 53 40 00                 call    dword_4053BC
.text:00401733 048 83 C4 20                          add     esp, 20h
.text:00401736 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401739 028 83 C0 01                          add     eax, 1
.text:0040173C 028 89 45 F0                          mov     [ebp+var_10], eax
.text:0040173F 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401742 028 99                                cdq
.text:00401743 028 52                                push    edx
.text:00401744 02C 50                                push    eax
.text:00401745 030 6A 00                             push    0
.text:00401747 034 68 B4 00 00 00                    push    0B4h ; '´'
.text:0040174C 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040174F 038 99                                cdq
.text:00401750 038 52                                push    edx
.text:00401751 03C 50                                push    eax
.text:00401752 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401755 040 99                                cdq
.text:00401756 040 52                                push    edx
.text:00401757 044 50                                push    eax
.text:00401758 048 FF 15 AC 53 40 00                 call    dword_4053AC
.text:0040175E 048 83 C4 20                          add     esp, 20h
.text:00401761 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:00401764 028 83 C1 01                          add     ecx, 1
.text:00401767 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:0040176A 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:0040176D 028 99                                cdq
.text:0040176E 028 52                                push    edx
.text:0040176F 02C 50                                push    eax
.text:00401770 030 6A 00                             push    0
.text:00401772 034 68 C8 00 00 00                    push    0C8h ; 'È'
.text:00401777 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040177A 038 99                                cdq
.text:0040177B 038 52                                push    edx
.text:0040177C 03C 50                                push    eax
.text:0040177D 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401780 040 99                                cdq
.text:00401781 040 52                                push    edx
.text:00401782 044 50                                push    eax
.text:00401783 048 FF 15 08 54 40 00                 call    dword_405408
.text:00401789 048 83 C4 20                          add     esp, 20h
.text:0040178C 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:0040178F 028 83 C2 01                          add     edx, 1
.text:00401792 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401795 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401798 028 99                                cdq
.text:00401799 028 52                                push    edx
.text:0040179A 02C 50                                push    eax
.text:0040179B 030 6A 00                             push    0
.text:0040179D 034 68 9B 00 00 00                    push    9Bh ; '›'
.text:004017A2 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004017A5 038 99                                cdq
.text:004017A6 038 52                                push    edx
.text:004017A7 03C 50                                push    eax
.text:004017A8 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004017AB 040 99                                cdq
.text:004017AC 040 52                                push    edx
.text:004017AD 044 50                                push    eax
.text:004017AE 048 FF 15 D8 53 40 00                 call    dword_4053D8
.text:004017B4 048 83 C4 20                          add     esp, 20h
.text:004017B7 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004017BA 028 83 C0 01                          add     eax, 1
.text:004017BD 028 89 45 F0                          mov     [ebp+var_10], eax
.text:004017C0 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004017C3 028 99                                cdq
.text:004017C4 028 52                                push    edx
.text:004017C5 02C 50                                push    eax
.text:004017C6 030 6A 00                             push    0
.text:004017C8 034 68 EF 00 00 00                    push    0EFh ; 'ï'
.text:004017CD 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004017D0 038 99                                cdq
.text:004017D1 038 52                                push    edx
.text:004017D2 03C 50                                push    eax
.text:004017D3 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004017D6 040 99                                cdq
.text:004017D7 040 52                                push    edx
.text:004017D8 044 50                                push    eax
.text:004017D9 048 FF 15 B8 53 40 00                 call    dword_4053B8
.text:004017DF 048 83 C4 20                          add     esp, 20h
.text:004017E2 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:004017E5 028 83 C1 01                          add     ecx, 1
.text:004017E8 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:004017EB 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004017EE 028 99                                cdq
.text:004017EF 028 52                                push    edx
.text:004017F0 02C 50                                push    eax
.text:004017F1 030 6A 00                             push    0
.text:004017F3 034 68 B4 00 00 00                    push    0B4h ; '´'
.text:004017F8 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004017FB 038 99                                cdq
.text:004017FC 038 52                                push    edx
.text:004017FD 03C 50                                push    eax
.text:004017FE 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401801 040 99                                cdq
.text:00401802 040 52                                push    edx
.text:00401803 044 50                                push    eax
.text:00401804 048 FF 15 C8 53 40 00                 call    dword_4053C8
.text:0040180A 048 83 C4 20                          add     esp, 20h
.text:0040180D 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:00401810 028 83 C2 01                          add     edx, 1
.text:00401813 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401816 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401819 028 99                                cdq
.text:0040181A 028 52                                push    edx
.text:0040181B 02C 50                                push    eax
.text:0040181C 030 6A 00                             push    0
.text:0040181E 034 68 B9 00 00 00                    push    0B9h ; '¹'
.text:00401823 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401826 038 99                                cdq
.text:00401827 038 52                                push    edx
.text:00401828 03C 50                                push    eax
.text:00401829 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040182C 040 99                                cdq
.text:0040182D 040 52                                push    edx
.text:0040182E 044 50                                push    eax
.text:0040182F 048 FF 15 E0 53 40 00                 call    dword_4053E0
.text:00401835 048 83 C4 20                          add     esp, 20h
.text:00401838 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040183B 028 83 C0 01                          add     eax, 1
.text:0040183E 028 89 45 F0                          mov     [ebp+var_10], eax
.text:00401841 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401844 028 99                                cdq
.text:00401845 028 52                                push    edx
.text:00401846 02C 50                                push    eax
.text:00401847 030 6A 00                             push    0
.text:00401849 034 6A 0A                             push    0Ah
.text:0040184B 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040184E 038 99                                cdq
.text:0040184F 038 52                                push    edx
.text:00401850 03C 50                                push    eax
.text:00401851 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401854 040 99                                cdq
.text:00401855 040 52                                push    edx
.text:00401856 044 50                                push    eax
.text:00401857 048 FF 15 18 54 40 00                 call    dword_405418
.text:0040185D 048 83 C4 20                          add     esp, 20h
.text:00401860 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:00401863 028 83 C1 01                          add     ecx, 1
.text:00401866 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:00401869 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:0040186C 028 99                                cdq
.text:0040186D 028 52                                push    edx
.text:0040186E 02C 50                                push    eax
.text:0040186F 030 6A 00                             push    0
.text:00401871 034 6A 57                             push    57h ; 'W'
.text:00401873 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401876 038 99                                cdq
.text:00401877 038 52                                push    edx
.text:00401878 03C 50                                push    eax
.text:00401879 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040187C 040 99                                cdq
.text:0040187D 040 52                                push    edx
.text:0040187E 044 50                                push    eax
.text:0040187F 048 FF 15 EC 53 40 00                 call    dword_4053EC
.text:00401885 048 83 C4 20                          add     esp, 20h
.text:00401888 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:0040188B 028 83 C2 01                          add     edx, 1
.text:0040188E 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401891 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401894 028 99                                cdq
.text:00401895 028 52                                push    edx
.text:00401896 02C 50                                push    eax
.text:00401897 030 6A 00                             push    0
.text:00401899 034 6A 5C                             push    5Ch ; '\'
.text:0040189B 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040189E 038 99                                cdq
.text:0040189F 038 52                                push    edx
.text:004018A0 03C 50                                push    eax
.text:004018A1 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004018A4 040 99                                cdq
.text:004018A5 040 52                                push    edx
.text:004018A6 044 50                                push    eax
.text:004018A7 048 FF 15 14 54 40 00                 call    dword_405414
.text:004018AD 048 83 C4 20                          add     esp, 20h
.text:004018B0 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004018B3 028 83 C0 01                          add     eax, 1
.text:004018B6 028 89 45 F0                          mov     [ebp+var_10], eax
.text:004018B9 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004018BC 028 99                                cdq
.text:004018BD 028 52                                push    edx
.text:004018BE 02C 50                                push    eax
.text:004018BF 030 6A 00                             push    0
.text:004018C1 034 68 FE 00 00 00                    push    0FEh ; 'þ'
.text:004018C6 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004018C9 038 99                                cdq
.text:004018CA 038 52                                push    edx
.text:004018CB 03C 50                                push    eax
.text:004018CC 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004018CF 040 99                                cdq
.text:004018D0 040 52                                push    edx
.text:004018D1 044 50                                push    eax
.text:004018D2 048 FF 15 50 54 40 00                 call    dword_405450
.text:004018D8 048 83 C4 20                          add     esp, 20h
.text:004018DB 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:004018DE 028 83 C1 01                          add     ecx, 1
.text:004018E1 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:004018E4 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004018E7 028 99                                cdq
.text:004018E8 028 52                                push    edx
.text:004018E9 02C 50                                push    eax
.text:004018EA 030 6A 00                             push    0
.text:004018EC 034 68 C5 00 00 00                    push    0C5h ; 'Å'
.text:004018F1 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004018F4 038 99                                cdq
.text:004018F5 038 52                                push    edx
.text:004018F6 03C 50                                push    eax
.text:004018F7 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004018FA 040 99                                cdq
.text:004018FB 040 52                                push    edx
.text:004018FC 044 50                                push    eax
.text:004018FD 048 FF 15 E8 53 40 00                 call    dword_4053E8
.text:00401903 048 83 C4 20                          add     esp, 20h
.text:00401906 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:00401909 028 83 C2 01                          add     edx, 1
.text:0040190C 028 89 55 F0                          mov     [ebp+var_10], edx
.text:0040190F 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401912 028 99                                cdq
.text:00401913 028 52                                push    edx
.text:00401914 02C 50                                push    eax
.text:00401915 030 6A 00                             push    0
.text:00401917 034 6A 6A                             push    6Ah ; 'j'
.text:00401919 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040191C 038 99                                cdq
.text:0040191D 038 52                                push    edx
.text:0040191E 03C 50                                push    eax
.text:0040191F 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401922 040 99                                cdq
.text:00401923 040 52                                push    edx
.text:00401924 044 50                                push    eax
.text:00401925 048 FF 15 D4 53 40 00                 call    dword_4053D4
.text:0040192B 048 83 C4 20                          add     esp, 20h
.text:0040192E 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401931 028 83 C0 01                          add     eax, 1
.text:00401934 028 89 45 F0                          mov     [ebp+var_10], eax
.text:00401937 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:0040193A 028 99                                cdq
.text:0040193B 028 52                                push    edx
.text:0040193C 02C 50                                push    eax
.text:0040193D 030 6A 00                             push    0
.text:0040193F 034 6A 73                             push    73h ; 's'
.text:00401941 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401944 038 99                                cdq
.text:00401945 038 52                                push    edx
.text:00401946 03C 50                                push    eax
.text:00401947 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040194A 040 99                                cdq
.text:0040194B 040 52                                push    edx
.text:0040194C 044 50                                push    eax
.text:0040194D 048 FF 15 1C 54 40 00                 call    dword_40541C
.text:00401953 048 83 C4 20                          add     esp, 20h
.text:00401956 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:00401959 028 83 C1 01                          add     ecx, 1
.text:0040195C 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:0040195F 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401962 028 99                                cdq
.text:00401963 028 52                                push    edx
.text:00401964 02C 50                                push    eax
.text:00401965 030 6A 00                             push    0
.text:00401967 034 6A 49                             push    49h ; 'I'
.text:00401969 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040196C 038 99                                cdq
.text:0040196D 038 52                                push    edx
.text:0040196E 03C 50                                push    eax
.text:0040196F 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401972 040 99                                cdq
.text:00401973 040 52                                push    edx
.text:00401974 044 50                                push    eax
.text:00401975 048 FF 15 2C 54 40 00                 call    dword_40542C
.text:0040197B 048 83 C4 20                          add     esp, 20h
.text:0040197E 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:00401981 028 83 C2 01                          add     edx, 1
.text:00401984 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401987 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:0040198A 028 99                                cdq
.text:0040198B 028 52                                push    edx
.text:0040198C 02C 50                                push    eax
.text:0040198D 030 6A 00                             push    0
.text:0040198F 034 68 BD 00 00 00                    push    0BDh ; '½'
.text:00401994 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401997 038 99                                cdq
.text:00401998 038 52                                push    edx
.text:00401999 03C 50                                push    eax
.text:0040199A 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:0040199D 040 99                                cdq
.text:0040199E 040 52                                push    edx
.text:0040199F 044 50                                push    eax
.text:004019A0 048 FF 15 44 54 40 00                 call    dword_405444
.text:004019A6 048 83 C4 20                          add     esp, 20h
.text:004019A9 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004019AC 028 83 C0 01                          add     eax, 1
.text:004019AF 028 89 45 F0                          mov     [ebp+var_10], eax
.text:004019B2 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004019B5 028 99                                cdq
.text:004019B6 028 52                                push    edx
.text:004019B7 02C 50                                push    eax
.text:004019B8 030 6A 00                             push    0
.text:004019BA 034 6A 11                             push    11h
.text:004019BC 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004019BF 038 99                                cdq
.text:004019C0 038 52                                push    edx
.text:004019C1 03C 50                                push    eax
.text:004019C2 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004019C5 040 99                                cdq
.text:004019C6 040 52                                push    edx
.text:004019C7 044 50                                push    eax
.text:004019C8 048 FF 15 58 54 40 00                 call    dword_405458
.text:004019CE 048 83 C4 20                          add     esp, 20h
.text:004019D1 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:004019D4 028 83 C1 01                          add     ecx, 1
.text:004019D7 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:004019DA 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:004019DD 028 99                                cdq
.text:004019DE 028 52                                push    edx
.text:004019DF 02C 50                                push    eax
.text:004019E0 030 6A 00                             push    0
.text:004019E2 034 68 D6 00 00 00                    push    0D6h ; 'Ö'
.text:004019E7 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004019EA 038 99                                cdq
.text:004019EB 038 52                                push    edx
.text:004019EC 03C 50                                push    eax
.text:004019ED 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:004019F0 040 99                                cdq
.text:004019F1 040 52                                push    edx
.text:004019F2 044 50                                push    eax
.text:004019F3 048 FF 15 20 54 40 00                 call    dword_405420
.text:004019F9 048 83 C4 20                          add     esp, 20h
.text:004019FC 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:004019FF 028 83 C2 01                          add     edx, 1
.text:00401A02 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401A05 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401A08 028 99                                cdq
.text:00401A09 028 52                                push    edx
.text:00401A0A 02C 50                                push    eax
.text:00401A0B 030 6A 00                             push    0
.text:00401A0D 034 68 8F 00 00 00                    push    8Fh
.text:00401A12 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401A15 038 99                                cdq
.text:00401A16 038 52                                push    edx
.text:00401A17 03C 50                                push    eax
.text:00401A18 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401A1B 040 99                                cdq
.text:00401A1C 040 52                                push    edx
.text:00401A1D 044 50                                push    eax
.text:00401A1E 048 FF 15 B0 53 40 00                 call    dword_4053B0
.text:00401A24 048 83 C4 20                          add     esp, 20h
.text:00401A27 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401A2A 028 83 C0 01                          add     eax, 1
.text:00401A2D 028 89 45 F0                          mov     [ebp+var_10], eax
.text:00401A30 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401A33 028 99                                cdq
.text:00401A34 028 52                                push    edx
.text:00401A35 02C 50                                push    eax
.text:00401A36 030 6A 00                             push    0
.text:00401A38 034 6A 6B                             push    6Bh ; 'k'
.text:00401A3A 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401A3D 038 99                                cdq
.text:00401A3E 038 52                                push    edx
.text:00401A3F 03C 50                                push    eax
.text:00401A40 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401A43 040 99                                cdq
.text:00401A44 040 52                                push    edx
.text:00401A45 044 50                                push    eax
.text:00401A46 048 FF 15 DC 53 40 00                 call    dword_4053DC
.text:00401A4C 048 83 C4 20                          add     esp, 20h
.text:00401A4F 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:00401A52 028 83 C1 01                          add     ecx, 1
.text:00401A55 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:00401A58 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401A5B 028 99                                cdq
.text:00401A5C 028 52                                push    edx
.text:00401A5D 02C 50                                push    eax
.text:00401A5E 030 6A 00                             push    0
.text:00401A60 034 6A 0A                             push    0Ah
.text:00401A62 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401A65 038 99                                cdq
.text:00401A66 038 52                                push    edx
.text:00401A67 03C 50                                push    eax
.text:00401A68 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401A6B 040 99                                cdq
.text:00401A6C 040 52                                push    edx
.text:00401A6D 044 50                                push    eax
.text:00401A6E 048 FF 15 64 54 40 00                 call    dword_405464
.text:00401A74 048 83 C4 20                          add     esp, 20h
.text:00401A77 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:00401A7A 028 83 C2 01                          add     edx, 1
.text:00401A7D 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401A80 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401A83 028 99                                cdq
.text:00401A84 028 52                                push    edx
.text:00401A85 02C 50                                push    eax
.text:00401A86 030 6A 00                             push    0
.text:00401A88 034 68 97 00 00 00                    push    97h ; '—'
.text:00401A8D 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401A90 038 99                                cdq
.text:00401A91 038 52                                push    edx
.text:00401A92 03C 50                                push    eax
.text:00401A93 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401A96 040 99                                cdq
.text:00401A97 040 52                                push    edx
.text:00401A98 044 50                                push    eax
.text:00401A99 048 FF 15 CC 53 40 00                 call    dword_4053CC
.text:00401A9F 048 83 C4 20                          add     esp, 20h
.text:00401AA2 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401AA5 028 83 C0 01                          add     eax, 1
.text:00401AA8 028 89 45 F0                          mov     [ebp+var_10], eax
.text:00401AAB 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401AAE 028 99                                cdq
.text:00401AAF 028 52                                push    edx
.text:00401AB0 02C 50                                push    eax
.text:00401AB1 030 6A 00                             push    0
.text:00401AB3 034 68 AB 00 00 00                    push    0ABh ; '«'
.text:00401AB8 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401ABB 038 99                                cdq
.text:00401ABC 038 52                                push    edx
.text:00401ABD 03C 50                                push    eax
.text:00401ABE 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401AC1 040 99                                cdq
.text:00401AC2 040 52                                push    edx
.text:00401AC3 044 50                                push    eax
.text:00401AC4 048 FF 15 24 54 40 00                 call    dword_405424
.text:00401ACA 048 83 C4 20                          add     esp, 20h
.text:00401ACD 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:00401AD0 028 83 C1 01                          add     ecx, 1
.text:00401AD3 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:00401AD6 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401AD9 028 99                                cdq
.text:00401ADA 028 52                                push    edx
.text:00401ADB 02C 50                                push    eax
.text:00401ADC 030 6A 00                             push    0
.text:00401ADE 034 6A 4E                             push    4Eh ; 'N'
.text:00401AE0 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401AE3 038 99                                cdq
.text:00401AE4 038 52                                push    edx
.text:00401AE5 03C 50                                push    eax
.text:00401AE6 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401AE9 040 99                                cdq
.text:00401AEA 040 52                                push    edx
.text:00401AEB 044 50                                push    eax
.text:00401AEC 048 FF 15 3C 54 40 00                 call    dword_40543C
.text:00401AF2 048 83 C4 20                          add     esp, 20h
.text:00401AF5 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:00401AF8 028 83 C2 01                          add     edx, 1
.text:00401AFB 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401AFE 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401B01 028 99                                cdq
.text:00401B02 028 52                                push    edx
.text:00401B03 02C 50                                push    eax
.text:00401B04 030 6A 00                             push    0
.text:00401B06 034 68 ED 00 00 00                    push    0EDh ; 'í'
.text:00401B0B 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401B0E 038 99                                cdq
.text:00401B0F 038 52                                push    edx
.text:00401B10 03C 50                                push    eax
.text:00401B11 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401B14 040 99                                cdq
.text:00401B15 040 52                                push    edx
.text:00401B16 044 50                                push    eax
.text:00401B17 048 FF 15 04 54 40 00                 call    dword_405404
.text:00401B1D 048 83 C4 20                          add     esp, 20h
.text:00401B20 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401B23 028 83 C0 01                          add     eax, 1
.text:00401B26 028 89 45 F0                          mov     [ebp+var_10], eax
.text:00401B29 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401B2C 028 99                                cdq
.text:00401B2D 028 52                                push    edx
.text:00401B2E 02C 50                                push    eax
.text:00401B2F 030 6A 00                             push    0
.text:00401B31 034 68 FE 00 00 00                    push    0FEh ; 'þ'
.text:00401B36 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401B39 038 99                                cdq
.text:00401B3A 038 52                                push    edx
.text:00401B3B 03C 50                                push    eax
.text:00401B3C 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401B3F 040 99                                cdq
.text:00401B40 040 52                                push    edx
.text:00401B41 044 50                                push    eax
.text:00401B42 048 FF 15 28 54 40 00                 call    dword_405428
.text:00401B48 048 83 C4 20                          add     esp, 20h
.text:00401B4B 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:00401B4E 028 83 C1 01                          add     ecx, 1
.text:00401B51 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:00401B54 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401B57 028 99                                cdq
.text:00401B58 028 52                                push    edx
.text:00401B59 02C 50                                push    eax
.text:00401B5A 030 6A 00                             push    0
.text:00401B5C 034 68 97 00 00 00                    push    97h ; '—'
.text:00401B61 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401B64 038 99                                cdq
.text:00401B65 038 52                                push    edx
.text:00401B66 03C 50                                push    eax
.text:00401B67 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401B6A 040 99                                cdq
.text:00401B6B 040 52                                push    edx
.text:00401B6C 044 50                                push    eax
.text:00401B6D 048 FF 15 60 54 40 00                 call    dword_405460
.text:00401B73 048 83 C4 20                          add     esp, 20h
.text:00401B76 028 8B 55 F0                          mov     edx, [ebp+var_10]
.text:00401B79 028 83 C2 01                          add     edx, 1
.text:00401B7C 028 89 55 F0                          mov     [ebp+var_10], edx
.text:00401B7F 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401B82 028 99                                cdq
.text:00401B83 028 52                                push    edx
.text:00401B84 02C 50                                push    eax
.text:00401B85 030 6A 00                             push    0
.text:00401B87 034 68 F9 00 00 00                    push    0F9h ; 'ù'
.text:00401B8C 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401B8F 038 99                                cdq
.text:00401B90 038 52                                push    edx
.text:00401B91 03C 50                                push    eax
.text:00401B92 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401B95 040 99                                cdq
.text:00401B96 040 52                                push    edx
.text:00401B97 044 50                                push    eax
.text:00401B98 048 FF 15 0C 54 40 00                 call    dword_40540C
.text:00401B9E 048 83 C4 20                          add     esp, 20h
.text:00401BA1 028 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401BA4 028 83 C0 01                          add     eax, 1
.text:00401BA7 028 89 45 F0                          mov     [ebp+var_10], eax
.text:00401BAA 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401BAD 028 99                                cdq
.text:00401BAE 028 52                                push    edx
.text:00401BAF 02C 50                                push    eax
.text:00401BB0 030 6A 00                             push    0
.text:00401BB2 034 68 98 00 00 00                    push    98h ; '˜'
.text:00401BB7 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401BBA 038 99                                cdq
.text:00401BBB 038 52                                push    edx
.text:00401BBC 03C 50                                push    eax
.text:00401BBD 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401BC0 040 99                                cdq
.text:00401BC1 040 52                                push    edx
.text:00401BC2 044 50                                push    eax
.text:00401BC3 048 FF 15 F4 53 40 00                 call    dword_4053F4
.text:00401BC9 048 83 C4 20                          add     esp, 20h
.text:00401BCC 028 8B 4D F0                          mov     ecx, [ebp+var_10]
.text:00401BCF 028 83 C1 01                          add     ecx, 1
.text:00401BD2 028 89 4D F0                          mov     [ebp+var_10], ecx
.text:00401BD5 028 8D 45 F4                          lea     eax, [ebp+var_C]
.text:00401BD8 028 99                                cdq
.text:00401BD9 028 52                                push    edx
.text:00401BDA 02C 50                                push    eax
.text:00401BDB 030 6A 00                             push    0
.text:00401BDD 034 6A 65                             push    65h ; 'e'
.text:00401BDF 038 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401BE2 038 99                                cdq
.text:00401BE3 038 52                                push    edx
.text:00401BE4 03C 50                                push    eax
.text:00401BE5 040 8B 45 F0                          mov     eax, [ebp+var_10]
.text:00401BE8 040 99                                cdq
.text:00401BE9 040 52                                push    edx
.text:00401BEA 044 50                                push    eax
.text:00401BEB 048 FF 15 38 54 40 00                 call    dword_405438
.text:00401BF1 048 83 C4 20                          add     esp, 20h
.text:00401BF4 028 6A 30                             push    30h ; '0'       ; Size
.text:00401BF6 02C BA 04 00 00 00                    mov     edx, 4
.text:00401BFB 02C C1 E2 00                          shl     edx, 0
.text:00401BFE 02C 8B 45 0C                          mov     eax, [ebp+argv]
.text:00401C01 02C 8B 0C 10                          mov     ecx, [eax+edx]
.text:00401C04 02C 51                                push    ecx             ; Buf2
.text:00401C05 030 68 18 50 40 00                    push    offset unk_405018 ; Buf1
.text:00401C0A 034 E8 C2 0C 00 00                    call    memcmp

  v6 = (int)argv[1];
  dword_40544C(v6, v6 >> 31, v6, v6 >> 31, 196, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053A8(v6, v6 >> 31, v6, v6 >> 31, 22, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053B4(v6, v6 >> 31, v6, v6 >> 31, 142, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053F0(v6, v6 >> 31, v6, v6 >> 31, 119, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405448(v6, v6 >> 31, v6, v6 >> 31, 5, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053FC(v6, v6 >> 31, v6, v6 >> 31, 185, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405400(v6, v6 >> 31, v6, v6 >> 31, 13, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405410(v6, v6 >> 31, v6, v6 >> 31, 107, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053F8(v6, v6 >> 31, v6, v6 >> 31, 36, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405430(v6, v6 >> 31, v6, v6 >> 31, 85, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053D0(v6, v6 >> 31, v6, v6 >> 31, 18, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405434(v6, v6 >> 31, v6, v6 >> 31, 53, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_40545C(v6, v6 >> 31, v6, v6 >> 31, 118, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405454(v6, v6 >> 31, v6, v6 >> 31, 231, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053C0(v6, v6 >> 31, v6, v6 >> 31, 251, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053E4(v6, v6 >> 31, v6, v6 >> 31, 160, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053C4(v6, v6 >> 31, v6, v6 >> 31, 218, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405440(v6, v6 >> 31, v6, v6 >> 31, 52, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053BC(v6, v6 >> 31, v6, v6 >> 31, 132, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053AC(v6, v6 >> 31, v6, v6 >> 31, 180, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405408(v6, v6 >> 31, v6, v6 >> 31, 200, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053D8(v6, v6 >> 31, v6, v6 >> 31, 155, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053B8(v6, v6 >> 31, v6, v6 >> 31, 239, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053C8(v6, v6 >> 31, v6, v6 >> 31, 180, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053E0(v6, v6 >> 31, v6, v6 >> 31, 185, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405418(v6, v6 >> 31, v6, v6 >> 31, 10, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053EC(v6, v6 >> 31, v6, v6 >> 31, 87, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405414(v6, v6 >> 31, v6, v6 >> 31, 92, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405450(v6, v6 >> 31, v6, v6 >> 31, 254, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053E8(v6, v6 >> 31, v6, v6 >> 31, 197, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053D4(v6, v6 >> 31, v6, v6 >> 31, 106, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_40541C(v6, v6 >> 31, v6, v6 >> 31, 115, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_40542C(v6, v6 >> 31, v6, v6 >> 31, 73, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405444(v6, v6 >> 31, v6, v6 >> 31, 189, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405458(v6, v6 >> 31, v6, v6 >> 31, 17, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405420(v6, v6 >> 31, v6, v6 >> 31, 214, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053B0(v6, v6 >> 31, v6, v6 >> 31, 143, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053DC(v6, v6 >> 31, v6, v6 >> 31, 107, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405464(v6, v6 >> 31, v6, v6 >> 31, 10, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053CC(v6, v6 >> 31, v6, v6 >> 31, 151, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405424(v6, v6 >> 31, v6, v6 >> 31, 171, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_40543C(v6, v6 >> 31, v6, v6 >> 31, 78, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405404(v6, v6 >> 31, v6, v6 >> 31, 237, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405428(v6, v6 >> 31, v6, v6 >> 31, 254, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_405460(v6, v6 >> 31, v6, v6 >> 31, 151, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_40540C(v6, v6 >> 31, v6, v6 >> 31, 249, 0, v7, (int)v7 >> 31);
  ++v6;
  dword_4053F4(v6, v6 >> 31, v6, v6 >> 31, 152, 0, v7, (int)v7 >> 31);
  dword_405438(v6 + 1, (v6 + 1) >> 31, v6 + 1, (v6 + 1) >> 31, 101, 0, v7, (int)v7 >> 31);
  v5 = memcmp(&unk_405018, argv[1], 0x30u);

.data:00405018 96 50 CF 2C EB 9B+    byte_405018     db  96h, 50h,0CFh, 2Ch,0EBh, 9Bh,0AAh,0FBh, 53h,0ABh, 73h
.data:00405018 AA FB 53 AB 73 DD+                                            ; DATA XREF: _main+885↑o
.data:00405018 6C 9E DB BC EE AB+                    db 0DDh, 6Ch, 9Eh,0DBh,0BCh,0EEh,0ABh, 23h,0D6h, 16h,0FDh
.data:00405018 23 D6 16 FD F1 F0+                    db 0F1h,0F0h,0B9h, 75h,0C3h, 28h,0A2h, 74h, 7Dh,0E3h, 27h
.data:00405018 B9 75 C3 28 A2 74+                    db 0D5h, 95h, 5Ch,0F5h, 76h, 75h,0C9h, 8Ch,0FBh, 42h, 0Eh
.data:00405018 7D E3 27 D5 95 5C+                    db 0BDh, 51h,0A2h, 98h

96 50 CF 2C EB 9B AA FB 53 AB 73 DD 6C 9E DB BC EE AB 23 D6 16 FD F1 F0 B9 75 C3 28 A2 74 7D E3 27 D5 95 5C F5 76 75 C9 8C FB 42 0E BD 51 A2 98