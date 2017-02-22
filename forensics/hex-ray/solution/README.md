hex-ray

This challenge is 6 images, 5 of which are encrypted (AES-CTR using
same key, IV).  Because CTR is basically a stream cipher, XORing (or
subtracting) the raw images will cancel out the cipher stream.  4 of
the images have been deleted from the FAT32 image.  By XORing the
pairs together parts of the message is revealed along the bottom.

The message is written in a braille font and is base64 encoding.  A
second line of braille below the first is used to indicate upper case
versus lower case vs number.
