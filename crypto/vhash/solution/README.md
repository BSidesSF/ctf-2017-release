# Solution for md5...

Go to the site and log in; you'll get a cookie set such as:

    auth=e4d689c098b13d8da9a211417dba116a|username=guest&date=2017-01-28T17:12:33-0800&secret_length=8&

Put that cookie's signature and value into hash_extender to add &username=administrator:

    $ ./hash_extender -d 'username=guest&date=2017-01-28T17:12:33-0800&secret_length=8&' -s 'e4d689c098b13d8da9a211417dba116a' -a '&username=administrator' -f md5 -l 8 --out-data-format html
    Type: md5
    Secret length: 8
    New signature: 20b2b9797bfaead8e204af5466ebced7
    New string: username%3dguest%26date%3d2017%2d01%2d28T17%3a12%3a33%2d0800%26secret%5flength%3d8%26%80%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%28%02%00%00%00%00%00%00%26username%3dadministrator

Send it with curl:

    $ curl -H 'Cookie: auth=20b2b9797bfaead8e204af5466ebced7%7Cusername%3dguest%26date%3d2017%2d01%2d28T17%3a12%3a33%2d0800%26secret%5flength%3d8%26%80%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%28%02%00%00%00%00%00%00%26username%3dadministrator' http://localhost/index.php
    <h1>Welcome back, administrator!</h1>
    <p>Congratulations, you're the administrator! Here's your reward:</p>
    <p>FLAG:180e2300112ef5a4f23c93cfdec8d780</p>
    <p><a href='/index.php?action=logout'>Log out</a></p>

And that's it!

# Solution for vhash...

First, one must reverse engineer the hash from the vhash binary.

Then, they have to implement a hash-extension attack against it.

The rest is pretty much the same. :)
