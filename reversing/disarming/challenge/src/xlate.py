fibs = []
xlate = []

fibs.append(1)
fibs.append(1)

for i in xrange(254):
    fibs.append(fibs[-1] + fibs[-2])

for i in xrange(256):
    xlate.append((fibs[i] ^ i) & 0x7F)

for i in xrange(0x20, 0x7F):
    if xlate[i] < 0x20:
        continue
    if xlate[i] > 0x7F:
        continue
    print('%r: %r' % (chr(i), chr(xlate[i])))
