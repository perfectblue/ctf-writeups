# uc_masteeer

* `is_admin` is set when pc=0xdeadbeef066, but the user code is overwritten with the admin code
* when the admin code runs it triggers a write to 0xbabecafe233 which runs a command and disables `is_admin`
* the top of the stack contains the address of the user/admin code
* since the stack is writeable, this address can be changed to jump to the start of MAIN instead
* the patch feature can now be used and `is_admin` is still set
* use the patch to rewrite the code to run our own command by writing to `0xbabecafe233`