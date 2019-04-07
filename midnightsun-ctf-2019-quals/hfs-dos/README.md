# Hfs-dos

**Category**: Reversing

350 Points

33 Solves

**Problem description**:
You don't need a modern 'secure' language when you write bug-free code :) The flag is in FLAG2 

---

Same challenge as before, but this stage now wants us to exploit it. The previous stage loads FreeDOS which loads our challenge binary. Nicely, the program also tells us where it loads.

```
[HFS SECURE SHELL] loaded at 100f:0100 (0x101f0) and ready for some binary carna
ge!
```

Again, setting up segments is quite annoying but the procedure to properly load this binary is to load it as a flat 16-bit segment at base 0x100. The value of `cs` doesn't matter because we will just tell IDA that it refers to our segment. This will allow IDA to recognize addresses in the code properly.

The binary basically implements a very trivial shell that implements 5 commands: `ping`, `pong`, `vers`, `myid`, and `exit`. None of these are vulnerable. The binary takes input from the keyboard for up to 4 characters at a time to read in commands. However, if you send the character 0x7f the program will interpret this as a backspace and move the read pointer backwards. Because it doesn't do any bounds checking we can use this to get out-of-bounds write. Unfortunately we are quite limited by which characters we can input. Doing some manual testing it seems like 0x01 doesn't work, and any characters above 0x7f don't work either. I think this is a limitation of DOS.

When the binary first starts, it reads the previous stages' flag from the file `FLAG1` on disk and prints it. If we look in memory around where our command is inputted, we notice something very interesting.

```
seg000:0389 switchTable     dw offset j_caseDefault ; DATA XREF: shellMain:switchOnCommand↑o
seg000:0389                                         ; jump table for switch statement
seg000:038B 65 01           dw offset j_casePong    ; jumptable 0000024E case 1
seg000:038D 68 01           dw offset j_caseVersion ; jumptable 0000024E case 2
seg000:038F 6B 01           dw offset j_caseMyid    ; jumptable 0000024E case 3
seg000:0391 6E 01           dw offset j_casePing    ; jumptable 0000024E case 4
seg000:0393 71 01           dw offset j_caseExit    ; jumptable 0000024E case 5
seg000:0395 flag_filename   db 'FLAG1',0,'$'        ; DATA XREF: openFlag+A↑o
seg000:039C inputtedCommand dw 0  
```

Since this is real-mode there is no need to worry about memory protection. It's pretty obvious what we will do. We'll go backwards from `inputtedCommand` to overwrite `FLAG1` to `FLAG2`, where our new flag is stored. We can also corrupt control flow by changing the switch statement's jump table. I overwrite the address to `j_caseExit` from 0x0171 to 0x014f, which was the address of the function that read and printed the flag. Then we just need to trigger it by inputting the `exit` command. This is enough to win the challenge.

```
[HFS-DOS]> command not found
[HFS-DOS]> command not found
[HFS-DOS]> exit
[HFS SECURE SHELL] Here is your flag for HFS-MBR: midnight{th4t_w
as_n0t_4_buG_1t_is_a_fEatuR3}
```
