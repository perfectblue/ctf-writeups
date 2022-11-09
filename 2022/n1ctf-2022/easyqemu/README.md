easyqemu
========

Bug in PMIO handler that lets us overflow while memcpy-ing because we can set arbitrary lengths.

This lets us read and write to the QEMUTimer object right after the buffer. We can leak the PIE address and then change it to system to run the command `/cat flag`
