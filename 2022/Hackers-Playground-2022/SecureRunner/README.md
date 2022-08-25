# Secure Runner

We can use the format string bug to modify 4 bytes of the RSA-CRT struct.
Modify `d_p` or `d_q` to use the well-known fault attack on RSA-CRT.