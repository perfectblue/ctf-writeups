set print array on
set print pretty on

define optee
	handle SIGTRAP noprint nostop pass
#	symbol-file $HOME/devel/optee/optee_os/out/arm/core/tee.elf
	target remote localhost:1234
end
document optee
	Loads and setup the binary (tee.elf) for OP-TEE and also connects to the QEMU
	remote.
end
