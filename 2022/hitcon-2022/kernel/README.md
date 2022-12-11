Fourchain - Kernel
==================

* Pretty straightforward UAF by racing edit and free using userfaultfd.
* Wasn't able to figure out how to leak KASLR so I just bruteforced it.
* Once we get the right UAF, we can just overwrite modprobe_path.
