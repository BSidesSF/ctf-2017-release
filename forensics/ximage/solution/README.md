The answer to this is simply that the image itself has to be run as
machine code. The run_raw_code.c program can do that. It's 32-bit x86.

extract_code.rb will extract out just the 'image' portion of the .bmp
file. This is no longer necessary since the entire image is runnable.
