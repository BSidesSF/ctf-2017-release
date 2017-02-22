import random

FLAG="Flag:ARM_Is_Not_Scary"


def byte_compare(pos, val):
    buf = "if (argv[1][%d] == '\\0' || argv[1][%d] != %d)"
    buf += "return %d;"
    buf += "\n"
    return buf % (pos, pos, ord(val), random.randint(1, 255))

def main():
    fp = open('easyarm.c', 'w')
    fpin = open('easyarm.c.in')

    buf = fpin.read()

    test = ""
    offsets = range(len(FLAG))
    for _ in xrange(3):
        random.shuffle(offsets)
        for o in offsets:
            test += byte_compare(o, FLAG[o])

    buf = buf.replace('%%MAGIC%%', test)

    fp.write(buf)
    fp.close()


if __name__ == '__main__':
    main()
