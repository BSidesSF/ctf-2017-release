This is a fairly simple/straight forward level.

Basically, the user sends some code with an md5 checksum. The server verifies
the checksum, then runs both the checksum and the code.

The trick is to find a checksum that can run. And, it turns out, that's pretty
easy; you just need a checksum that starts with "\xeb\x0e". Since you can
append anything random after your code, it's just a matter of figuring out what
to append!

The solution/ just makes a breakpoint happen, but can very easily be expanded
to arbitrary code.
