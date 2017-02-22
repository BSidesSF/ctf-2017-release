# encoding: ASCII-8bit

require 'digest'

DESIRED_PREFIX = "\xeb\x0e"
DESIRED_CODE = "\xCC"

0.upto(0xFFFFFFFFFFFFFFFF) do |i|
  this_code = DESIRED_CODE + [i].pack('q')
  checksum = Digest::MD5.digest(this_code)

  if(checksum.start_with?(DESIRED_PREFIX))
    puts "Code: %s" % (this_code.bytes.map { |c| '\x%02x' % c }).join()
    puts "Checksum: %s" % (checksum.bytes.map { |c| '\x%02x' % c }).join()
    puts("Checksum: %s" % checksum.unpack("H*"))
    break
  end
end
