# Rustyschool

Category: Reversing

406 points, 6 solves

**Solved by: superfashi, Riatre, cts**

**Writeup author: cts**

---

This is a fairly straightforward flag decryptor style reversing challenge. The gimmick is that it's a Rust binary so it's fucking impossible to read.

![video](./docs/screenshot.mp4)

Unfortunately, the year is 2024 and there is yet to be a high-quality Rust decompiler on the market. Hex-Rays is a gold standard for native decompilation, but it the pseudo-C it produces is extremely verbose. This is especially true considering the large amount of syntactic sugar Rust provides. Unfortunately, Rust pushes programmers to *actually consider errors and handle them*, much to the detriment of us reverse engineers. A single-character `?` operator can produce dozens of lines of boilerplate in pseudo-C.
