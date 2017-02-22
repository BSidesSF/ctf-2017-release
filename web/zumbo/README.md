# Zumbo
Category: Web
Difficulty: easy, easy, medium


Designed by Jimmy Tang

### How to get flags:

flag1: file inclusion: get /server.py (html comments basically give this away)

flag2: path traversal to get environment variable: get /../flag (slashes probably have to be %2F escaped)

flag3: template injection: something something {{"".__class__.mro()[1].__subclasses__()}} something something. `solve3.py` is solution code.
