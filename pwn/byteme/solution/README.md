The challenge reads a maximum of 140 bytes, and it loads it as
bytecode and tries to run it.

We want to get the string 'key' out. Because we're behind xinetd, the
short naive solution is to put this in a file (say, test.lua):

    print(key)

and then compile it with 'luac'. While this will produce a valid
bytecode chunk that *would* work, it will contain the 'source name'
(part of the Lua bytecode format) and it will be too long.

If, say, we do the following:

    io.write(string.dump(loadstring('print(key)')))

and capture the output when running this with the Lua interpreter, we
will get similar bytecode, except that the 'source name' will be:

    =stdin

Instead of the following from the previous attempt:

    @test.lua


Because the 'source name' field of a bytecode chunk may be empty, we
can replace the length field (usually four bytes prior to the string)
with all zeroes and then remove the string following it (including the
null-terminating byte) to get the bytecode to the appropriate size.

There may be other ways to shrink the bytecode down, I just haven't
thought of them. Bring on the creative solutions!

The information to solve this challenge, despite being for Lua 5.1,
can be found here:

http://luaforge.net/docman/83/98/ANoFrillsIntroToLua51VMInstructions.pdf
