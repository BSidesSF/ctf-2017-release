The solution is quite simple.. it's just one character per packet.

The easiest solution is:
* Open in Wireshark
* Right-click on any packet and click "Follow -> TCP Stream"

Another solution is:
* Open in Wireshark
* Set the display filter "tcp.len > 0"
* Go to each packet, and record the one byte of data

FLAG:385b87afc8671dee07550290d16a8071
