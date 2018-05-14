opening the pcap in wireshark, we can see some png data being transmitted.
follownig the http stream, we can get the png.

alternatively a quick-and-dirty solution is to notice the PNG header within the hex dump, and manually carve it out.
the resulting png is cut off but it suffices to read th flag.

![test.png](test.png)
