# Superbee

- Also straight up code review. 
- Server fetched a non-existing config attribute (and padded it) to use as AES password to encrypt the auth key. It was only accessible if the domain part was set to "localhost" however
```
Th15_sup3r_s3cr3t_K3y_N3v3r_B3_L34k3d
```
