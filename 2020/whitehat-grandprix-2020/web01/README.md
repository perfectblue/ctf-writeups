# Web 01
## Recon
This challenge introduces two bugs, one of which leads to solution:
There's SSRF and LFI in `page` parameter.<br>

After trying multiple files, we realised that there's some sort of filtering in place that prevents directly including files such as `/etc/passwd`.<br>

To bypass filter we use `/./` prefix to path. This way it's possible to dump `/etc/passwd`. Example: `http://15.165.80.50/?page=/./etc/passwd`

## Getting RCE

First thing I enumerated was `/proc/self/fd/X` where `X` corresponds to file descriptor.
On file descriptor 11 there was a session file that contained our username.
Assuming the file is getting included and not just printed out, I tried to include php shell in the username and that worked.

Final steps:
1. Register user with php code in name
2. login
3. include /./proc/self/fd/11 (http://15.165.80.50/?page=/./proc/self/fd/11)

## Flag
`WhiteHat{Local_File_Inclusion_bad_enough_??}`
