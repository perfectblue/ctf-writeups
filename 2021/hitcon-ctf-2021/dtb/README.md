# dtb

This challenge allows us to provide arbitrary `example.dtb` file, and the server will run Aarch64 Linux kernel with QEMU using the following command:

```shell
qemu-system-aarch64 -M virt,dtb=example.dtb \
  -nographic -monitor none \
  -smp 1 -m 2048 \
  -kernel ./Image.gz -append "console=ttyAMA0 panic=-1 oops=panic" \
  -initrd ./rootfs.cpio.gz \
  -no-reboot -cpu cortex-a72
```

The kernel version is v5.15.6, and the fixed file system is as a initramfs format. It contains a simple binary `/Init` that prints two strings and reboots. The flag is stored as `/flag` in the file system. Kernel protections like SMEP/SMAP/kASLR were all disabled. Since the file system is a simple initramfs, we can solve the problem with a read primitive that allows us to print string from the flag's address after initramfs decompression.

**TL;DR**

1. Add a second CPU with `enable-method = "spin-table"` and `cpu-release-addr = <0x41df0f88>`. This writes a fixed value `0x000000004111c21c (&secondary_holding_pen)` to the address.
2. With that address overwritten, we can place regmaps on the kernel code region. Place syscon LED devices on kernel code region and flip bits with `default-state = "on|off"`.
3. An LED device prints its name after initialization. Its name is composed from the properties including the color. Patch the kernel to make an LED device loads its color name from the flag location.

We thought of two high-level approaches: (1) attacking the dtb parser itself and (2) finding a suitable device driver that can be easily manipulated with dtb. After spending a lot of time in both directions, we decided to focus on the second approach because we couldn't find any useful bug in the dtb (device tree in binary format) parser unlike the dts (device tree in human-readable format) parser used in [dtcaas](../../dtcaas) challenge. We started grepping the linux source code for the use of device tree APIs such as `of_get_property`, `of_property_read_u32/64`, etc.

The first primitive we found was arbitrary write of a fixed value using `enable-method = "spin-table"` and `cpu-release-addr` in a CPU node. [Spin table](https://tc.gts3.org/cs3210/2020/spring/lab/lab5.html#subphase-a-waking-up-other-cores) is a mechanism to wake up CPUs in multi-core ARM system, and it allows us to write `0x000000004111c21c (&secondary_holding_pen)` to any address of our choice:

```
cpu@1 {
    reg = <0 1>;
    compatible = "arm,cortex-a72";
    enable-method = "spin-table";
    cpu-release-addr = <0 [addr]>;
};
```

The second primitive we found was a memory remap using Xen's UEFI functionality. This lets us to control the physical address that backs the kernel allocation: kernel tries to remove all `memblock`s, which contains the list of physical address available for allocating virtual memory, and populate them using UEFI's memory descriptor information (See `efi-init.c : reserve_regions`). We did not use this primitive in the final exploit, but this primitive looked promising at this stage.

After having these two relatively powerful primitives, we tried various methods to read the flag for a few hours such as creating a custom DMA / IOMMU controller that copies the flag values and crashing the kernel with an invalid flash device to leak the flag from the kernel dump. All those attempts failed, and we were losing hope until we found the third primitive that allowed us to solve the problem.

The third primitive we found was a syscon LED device. An LED device takes properties such as a color, function, and label from the device tree and composes its name. Thanks to us, it prints out its name to the kernel log after the initialization. The color property is particularly interesting because it is provided as an integer in the device tree and mapped to a string using an array. We realized that if we can bypass the bound check in the color name array, we will be able to read the flag:

```c
/* `led_compose_name` in `drivers/leds/led-core.c` */
// parse LED properties
led_parse_fwnode_props(dev, fwnode, &props);

// ...
} else if (props.function || props.color_present) {
    char tmp_buf[LED_MAX_NAME_SIZE];

    // integer color property is mapped to a string
    // we want `props.color_present` to be set with OOB `props.color`
    if (props.func_enum_present) {
        snprintf(tmp_buf, LED_MAX_NAME_SIZE, "%s:%s-%d",
                 props.color_present ? led_colors[props.color] : "",
                 props.function ?: "", props.func_enum);
    } else {
        snprintf(tmp_buf, LED_MAX_NAME_SIZE, "%s:%s",
                 props.color_present ? led_colors[props.color] : "",
                 props.function ?: "");
    }
    
    // ...
    
    // LED name is set
    strscpy(led_classdev_name, tmp_buf, LED_MAX_NAME_SIZE);
}
```

We first tried overwriting the bound check code with the spin table primitive. However, it was a little difficult to achieve because the overwritten value is 8 bytes, and they should be parsed as valid ARM instructions. Then, we realized that an LED device can be upgraded to a much more powerful primitive: arbitrary bitflip. We can make the system controller regmap overlapping with the kernel code region, and flip the bits with `default-state = "on|off"` in the device tree's LED node.

```c
/* `syscon_led_probe` in `drivers/leds/leds-syscon.c` */
state = of_get_property(np, "default-state", NULL);
if (state) {
    if (!strcmp(state, "keep")) {
        // ...
    } else if (!strcmp(state, "on")) {
        sled->state = true;
        ret = regmap_update_bits(map, sled->offset,
                                 sled->mask,
                                 sled->mask);
        if (ret < 0)
            return ret;
    } else {
        sled->state = false;
        ret = regmap_update_bits(map, sled->offset,
                                 sled->mask, 0);
        if (ret < 0)
            return ret;
    }
}
```

Regmap overlapping doesn't work by default because of `memblock_is_memory` which scans `memblock.memory`, but overwriting `memblock.memory.regions[0].base` (`0x41df0f88`) with the spin table primitive allows us to bypass the check. With the overlapping regmap, we could flip arbitrary bit in the kernel code, and patching the kernel to make an LED device loads its color name from the flag location was straightforward.

[This is our final exploit (example.dts).](./example.dts) and [generator](./xor_patcher.py)
