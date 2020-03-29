from ELFPatch import ELFPatch 
from pwn import *

context.arch = 'amd64'

f = ELFPatch(b"./f-hash")

new_patch = f.new_patch(virtual_address=0x13B0, size=0x200,
        append_jump_back=True, append_original_instructions=True)
chk = f.new_chunk(0x20 * 258)
assert 0x206d70 == chk.virtual_address

new_patch.update_patch(asm("""
.start:
push r12
push rbx

push rdi
push rsi
push rdx
push rcx

// Check that arg3 and arg4 are same
lea rax, [rip + .start - 0x204d60 + 0x206d70]
cmp rdx, [rax]
jne set_zero
cmp rcx, [rax+8]
jne set_zero
jmp end_set

set_zero:
push rdi
mov rdi, rax
mov rax, rdx
stosq
mov rax, rcx
stosq

xor rax, rax
mov ecx, 4 * 258
rep stosq
pop rdi

end_set:



shl rsi, 5
lea rbx, [rip + .start - 0x204d60 + 0x206d80]
lea rax, [rbx + rsi]

mov rdx, [rbx + rsi] 
lea rbx, [rbx + rsi + 8]
test rdx, rdx
jz do_callfn

// Else just copy from our local memoized
mov rdx, 0x18
mov rsi, rbx
// memcpy
call 0xC90 
pop rcx
pop rdx
pop rsi
pop rdi
pop rbx
pop r12
ret

do_callfn:
pop rcx
pop rdx
pop rsi
pop rdi

mov r12, rdi
push rsi
call fn
retback:


// memoize it
mov rdx, 0x18
mov rsi, r12
mov rdi, rbx
pop rax
// memcpy
call 0xC90
mov qword ptr [rbx - 8], 1

pop rbx
pop r12
ret

fn:

""", vma=new_patch.chunk.virtual_address))

# new_patch.update_patch(b"\x48\xC7\xC0\x01\x00\x00\x00\x48\xC7\xC7\x01\x00\x00\x00\xEB\x0C\x5E\x48\xC7\xC2\x0C\x00\x00\x00\x0F\x05\xEB\x12\xE8\xEF\xFF\xFF\xFF\x53\x49\x43\x45\x44\x20\x50\x41\x54\x43\x48\x0A\x00")


assert(new_patch.chunk.virtual_address == 0x204d60)
print("New Patch at", hex(new_patch.chunk.virtual_address))
f.write_file("./out3")
