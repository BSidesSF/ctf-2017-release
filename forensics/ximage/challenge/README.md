This level works by giving the user .bmp images that are literally executable.
They can be loaded into memory and run (on a 32-bit processor).

To embed the code, run:

    ruby ./create_code.rb FLAG:c3dbbf0298eceb3edcd6d2505fd8d30d
    ruby ./embed_code.rb code.asm <in_file> <out_file>

It will endeavour to replace every pixel in the original file with the closest
NOP it can find.
