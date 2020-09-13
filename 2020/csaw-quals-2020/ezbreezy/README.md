# Easy Breezy

Solved by cts

Basically there is another segment in the binary (*THAT IS NEVER USED*) which basically has a function that also does nothing. BUT WAIT, apply your guess god skills, and notice that its building a buffer on the stack with individual move instructions. So then copy this out and print it, but it's still not a flag?!?!?!

Ok, so then u try to xor each byte with a constant, STILL NOT A FLAG?!?!?!

OK but this is low point reversing so it has to be some other very simple guessgod cipher. And what is the first one that comes to mind. BYTE WISE ADDITION CIPHER. Caesar cipher with key=0x40. Subtract every byte by 0x40

flag{u_h4v3_r3c0v3r3d_m3}
