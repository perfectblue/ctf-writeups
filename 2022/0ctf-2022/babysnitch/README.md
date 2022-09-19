BabySnitch
----------


As docker allows us to bind to privileged ports, we can send a UDP request with srcport 53 and dstport 53 to exfil the flag.

The firewall checks to make sure it's a valid DNS response, so we need to ensure the packet is a valid format and smuggle the flag inside.

Check `solve.c` for the solution.
