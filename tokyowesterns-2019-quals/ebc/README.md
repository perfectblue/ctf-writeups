# Behemoth

This is an UEFI Bytecode reverse engineering challenge. It's a typical flag checker binary, except it runs in UEFI.

The first challenge was simply getting the challenge to run. To do this I used qemu-system. However, we need to load a special firmware into Qemu to support UEFI. This can be downloaded from [Tianocore EDK](https://www.kraxel.org/repos/jenkins/edk2/). Then we're able to drop to a EFI shell.

```
# mkdir image # create virtual FAT32 filesystem image passed to guest
# cp ebc image/
# cp edk2-img/usr/share/edk2.git/ovmf-x64/OVMF-pure-efi.fd .
# qemu-system-x86_64 -net none -monitor none -parallel none -bios OVMF-pure-efi.fd -L . -hda fat:rw:image
```

We are greeted by a nice splash screen and a shell. Then we can switch to our mapped filesystem and run the challenge.

![pics/qemu1.png]()

It's pretty clear this is a flag checker binary. In that case let's load into IDA and begin static analysis. There is a processor module that ships with IDA but unfortunately it has a few bugs :-( Luckily the processor module is written in Python so we are easily able to modify it.

![pics/idabugs.png]()

Also, the processor module doesn't support the type system which is extremely annoying.

![pics/typesystem.png]()

I fixed the bugs in the processor module including one where MOVIxx instructions were not decoding 64-bit operands correctly. I've included the fixed module code in `ebc-ida-proc-module.py`, you can locate the edited regions by searching for `PATCH:`.

The challenge is made of 5 main stages: reading a key from keyboard, then 4 encrypted stages decrypted with xor. Each stage checks 8 bytes of the flag, and the flag is 32 bytes total. For all stages but the first stage, the decryption key is the CRC32 of the previous stage's solution. The first stage's decryption key is just hardcoded. I wrote a small C program (`fuck.c`) to do this decryption.

![pics/cfg.png]

Let's dig into the code. The main function has the 5 stages I described. Notice all of the i/o is done using EFI system services. Luckily we can load all of the EFI structs so it is quite easy to understand the code. For an example let's look at the simple function that simply just reads a character of input from the keyboard.

![pics/codenz.png]

The code should be pretty self explanatory but it's a good example of what the code in this VM looks like. Back in the main function, we're passed the image handle and EFI system table as arguments, and the system table is stored for use in the program. Notice the calling convention is cdecl so arguments are passed right to left on stack.

```
.text:000000000040111C                       ; __int64 start(__int64 ImageHandle, __int64 SystemTable)
.text:000000000040111C                       public start
.text:000000000040111C                       start
.text:000000000040111C
.text:000000000040111C 000 79 01 E0 0E       MOVRELw     R1, SystemTable   ; Load IP-relative address
.text:0000000000401120 000 72 89 41 10       MOVnw       [R1], [SP+SystemTable] ; Move unsigned n
```

Each of the stages' check functions is just a single basic block that validates an argument in a complicated fashion then returns 0 or 1. We want it to return 1.

```
seg002:00000000
seg002:00000000                       ; Segment type: Pure code
seg002:00000000
seg002:00000000
seg002:00000000
seg002:00000000                       stage1_check:
seg002:00000000
seg002:00000000                       arg_0=  0x10
seg002:00000000
seg002:00000000 000 60 81 02 10       MOVqw       R1, [SP+arg_0]    ; Move qword
seg002:00000004 000 F7 32 F2 28 F6 95+MOVIqq      R2, 0xBB5D75B895F628F2 ; Move immediate value
seg002:0000000E 000 F7 33 8B 7B 73 C6+MOVIqq      R3, 0xD30A286EC6737B8B ; Move immediate value
seg002:00000018 000 F7 34 55 51 68 5D+MOVIqq      R4, 0x1BFA530D5D685155 ; Move immediate value
seg002:00000022 000 F7 35 55 33 08 D2+MOVIqq      R5, 0xA29C4DB3D2083355 ; Move immediate value
seg002:0000002C 000 F7 36 34 51 FF B2+MOVIqq      R6, 0xAB0A0D83B2FF5134 ; Move immediate value
seg002:00000036 000 F7 37 3D AB 69 E3+MOVIqq      R7, 0x67518339E369AB3D ; Move immediate value
seg002:00000040 000 4C 61             ADD64       R1, R6            ; Op1 += Op2
seg002:00000042 000 4D 51             SUB64       R1, R5            ; Op1 -= Op2
seg002:00000044 000 F7 37 AE 52 B4 CB+MOVIqq      R7, 0xDA1298C4CBB452AE ; Move immediate value
seg002:0000004E 000 56 71             XOR64       R1, R7            ; Op1 ^= Op2
seg002:00000050 000 4D 61             SUB64       R1, R6            ; Op1 -= Op2
...
seg003:00000744 000 45 71             CMP64eq     R1, R7            ; Compare if equal
seg003:00000746 000 82 03             JMP8cc      loc_80274E        ; Jump to address if condition i
```

To do this we will use Z3. We need to essentially generate a system of equation automatically from the disassembly. Systems like angr exist but obviously there would be no support for such a bizarre and disused architecture like EBC VM. So we will just reinvent the wheel, lol. To do this I simply just wrote a quick-and-dirty grammar for the disassembly listing IDA generates. Then we parse the listing and iterate through and simulate each instruction. As we do this, we number all registers in an SSA fashion and at each assignment we generate a new equation for the solver. Then it is straightforward to solve all of the stages one at a time. Each stage seem to be more complicated than the previous one, but only in superficial ways such as adding new instructions to the mix or adding extra branches. Refer to solve script (`solve.py`).

The final stage is the most interesting one. In this one not only the flag data is an input to the check function but so is the CRC32 of the flag data. This creates an interesting system for us.

```
.text:00000000004012B8
.text:00000000004012B8                       stage4:
.text:00000000004012B8 000 79 03 44 0D       MOVRELw     R3, SystemTable   ; Load IP-relative address
.text:00000000004012BC 000 20 B3             MOVqw       R3, [R3]          ; Move qword
.text:00000000004012BE 000 72 B3 89 21       MOVnw       R3, [R3+EFI_SYSTEM_TABLE.BootServices] ; Move unsigned natural value
.text:00000000004012C2 000 79 01 B4 0D       MOVRELw     R1, encryptionkey ; OUT Crc32
.text:00000000004012C6 000 35 01             PUSHn       R1                ; Push natural value on the stack
.text:00000000004012C8 008 77 31 08 00       MOVIqw      R1, 8             ; IN DataSize
.text:00000000004012CC 008 35 01             PUSHn       R1                ; Push natural value on the stack
.text:00000000004012CE 010 79 01 C8 0D       MOVRELw     R1, keyData+0x18  ; IN Data
.text:00000000004012D2 010 35 01             PUSHn       R1                ; Push natural value on the stack
.text:00000000004012D4 018 83 2B 28 18 00 20 CALL32EXa   [R3+EFI_BOOT_SERVICES.CalculateCrc32] ; Call an external subroutine (via thunk) [absolute addressing]
.text:00000000004012DA 018 60 00 03 10       MOVqw       SP, SP+0x18       ; Move qword
.text:00000000004012DE 000 79 01 98 0D       MOVRELw     R1, encryptionkey ; Load IP-relative address
.text:00000000004012E2 000 77 32 00 00       MOVIqw      R2, 0             ; Move immediate value
.text:00000000004012E6 000 1F 92             MOVdw       R2, [R1]          ; Move dword
.text:00000000004012E8 000 35 02             PUSHn       R2                ; Push natural value on the stack
.text:00000000004012EA 008 79 01 AC 0D       MOVRELw     R1, keyData+0x18  ; Load IP-relative address
.text:00000000004012EE 008 20 91             MOVqw       R1, [R1]          ; Move qword
.text:00000000004012F0 008 6B 01             PUSH64      R1                ; Push value on the stack
.text:00000000004012F2 010 83 10 5C 00 00 00 CALL32      OEP               ; Call a subroutine
.text:00000000004012F8 010 60 00 02 10       MOVqw       SP, SP+0x10       ; Move qword
.text:00000000004012FC 000 77 31 01 00       MOVIqw      R1, 1             ; Move immediate value
.text:0000000000401300 000 45 71             CMP64eq     R1, R7            ; Compare if equal
.text:0000000000401302 000 82 27             JMP8cc      end               ; Jump to address if condi
```

However CRC32 is extremely simple so it can be modelled in Z3 with no problem.

```python
def crc32(data,size,polynomial=0xEDB88320):
    crc = 0xFFFFFFFF
    for i in range(0,size,8):
        crc = crc ^ (LShR(data,i) & 0xFF)
        for _ in range(8):
            crc = If(crc & 1 == BitVecVal(1, size), LShR(crc,1) ^ polynomial, LShR(crc,1))
    return crc ^ 0xFFFFFFFF
```

The final flag is `# TWCTF{EBC_1n7erpret3r_1s_m4d3_opt10n4l}`. It was fun challenge.
