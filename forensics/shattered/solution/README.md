shattered

This challenge takes random segments of a jpg image and transmits them
in the data section of a TCP ACK packet.  The segments are chosen at
random but the sequence number indicates where in the file the chunk
came from.  There are many overlapping sections of the image
transmitted over and over so there is far more than enough data to
reconstruct the whole image.  The difficulty in this challenge is
manually doing the TCP stream reassembly.  Wireshark can't be used to
reconstruct this stream because it isn't a proper TCP conversation.
