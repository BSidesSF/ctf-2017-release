import secretsharing  # need version from git
import binascii

x = [31337, 1337, 735]
y = [74755106547149950494298118376047078452,
     328103284834185548901467840973205257218,
     234731986215211726774334392959253481398]
p = 340282366920938463463374607431768211507

points = zip(x,y)

secret = secretsharing.points_to_secret_int(points, p)
secret = binascii.unhexlify('%x' % secret)
print secret
