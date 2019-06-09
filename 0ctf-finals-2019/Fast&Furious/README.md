# Fast&Furious
**Category**: Pwn

250 Points

10 Solves

---

Full write-up coming soon. For now please refer to [hax.c](hax.c).
It's a lot like the [Blazeme](../../blazectf-2018/blazeme-420) challenge from Blazectf 2018, but with SMEP and KPTI. That makes our life more tricky since we cannot return directly to userland: even if we disable SMEP, under KPTI the kernel page table has all user pages marked as NX. Instead we use a ropchain to `commit_creds` then return to the KTPI exit trampoline that swaps CR3 properly. If we don't swap CR3 back to the userland page table we will double fault when we try to step on the first userland instruction after returning.

Another less elegant option is to simply chmod the flag then hang in the kernel, then view the flag on a different core. See [voidexp.c](voidexp.c) for this.

Solved as group effort by VoidMercy, Jazzy, cts, theKidOfArcania, and jonathanj
